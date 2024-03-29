require "../shopify"
require "json"
require "http/client"
require "./erroring_response"

abstract class Shopify::Resource
  include JSON::Serializable

  @[JSON::Field(ignore: true)]
  property store : Store = Store.new("unknown.myshopify.com")

  def self.headers
    HTTP::Headers{
      "Content-Type" => "application/json",
    }
  end

  class NextPreviousParser
    def initialize(@links : String)
    end

    def next
      @links.split(",").find do |link|
        link.includes?("rel=\"next\"")
      end
    end

    def previous
      @links.split(",").find do |link|
        link.includes?("rel=\"previous\"")
      end
    end

    def next_link
      self.next.try &.split(";").first.strip.gsub("<", "").gsub(">", "")
    end

    def previous_link
      previous.try &.split(";").first.strip.gsub("<", "").gsub(">", "")
    end
  end

  private module ClassMethods
    abstract def uri(domain : String, path : String = "") : URI
  end

  macro inherited
    extend ClassMethods

    def self.with(store : Store)
      WithStore(self).new(store)
    end
  end

  macro findable
    # Used to fetch one {{@type.id.split("::").last.downcase.id}}.
    #
    # Generally, this is used with `.with(store)`:
    # ```crystal
    # {{@type.id}}.with(store).find(id) #=> {{@type.id}}
    # ```
    # But it can be used stand-alone, too:
    #
    # ```crystal
    # {{@type.id}}.find(id, domain, headers: headers) #=> {{@type.id}}
    # ```
    #
    # Under the covers, this just runs:
    # ```plaintext
    # GET
    # /admin/api/2022-01/{{@type.id.split("::").last.downcase.id}}s/{id}.json
    # ```
    def self.find(id : Int64, domain : String, headers : HTTP::Headers = headers) : {{@type.id}}
      JSON::PullParser.new(
        ErroringResponse.new(
          HTTP::Client.get(uri(domain, "/#{id}"), headers)
        ).body
      ).try do |pull|
        pull.read_begin_object
        pull.read_object_key

        from_json(pull.read_raw)
      end
    end
  end

  macro indexable
    # Used to return an array of {{@type.id.split("::").last.downcase.id}}s. Uses fibers to fetch pages concurrently.
    #
    # NOTE: It is recommended to use `.all(domain, next_page_uri, headers, &block)`
    # directly instead of this method as it is more performant.
    #
    # Generally, this is used with `.with(store)`:
    # ```crystal
    # {{@type.id}}.with(store).all #=> Array({{@type.id}})
    # ```
    # But it can be used stand-alone, too:
    #
    # ```crystal
    # {{@type.id}}.all(domain, headers: headers) #=> Array({{@type.id}})
    # ```
    #
    # This just runs the `&block` version of `.all(domain, next_page_uri, headers, &block)` to create an array
    def self.all(domain : String, depth : Int32 = 20, headers : HTTP::Headers = headers) : Array({{@type.id}})
      resources = [] of self

      all(domain, depth: depth, headers: headers) do |resource|
        resources << resource
      end

      resources
    end

    # Used to iterate over all {{@type.id.split("::").last.downcase.id}}s. Uses fibers to fetch pages concurrently.
    #
    # Generally, this is used with `.with(store)`:
    # ```crystal
    # {{@type.id}}.with(store).all do |{{@type.id.split("::").last.downcase.id}}|
    #   # do something with {{@type.id.split("::").last.downcase.id}}
    # end
    # ```
    # But it can be used stand-alone, too:
    #
    # ```crystal
    # {{ @type }}.all(domain, headers: headers) do |{{@type.id.split("::").last.downcase.id}}|
    #   # do something with {{@type.id.split("::").last.downcase.id}}
    # end
    # ```
    #
    # Under the covers, this just runs:
    # ```plaintext
    # GET
    # /admin/api/2022-01/{{@type.id.split("::").last.downcase.id}}s.json
    # ```
    # and follows every next Response Headers "Link" until there are no more.
    #
    # Uses `NextPreviousParser` to parse the response headers.
    def self.all(
      domain : String,
      next_page_uri : String? = nil,
      depth : Int32 = 20,
      headers : HTTP::Headers = headers,
      &block : self ->
    )
      return if depth <= 0

      ErroringResponse.new(
        HTTP::Client.get(
          next_page_uri || uri(domain),
          headers
        )
      ).try do |response|
        channel = Channel(Nil).new
        spawn do
          NextPreviousParser.new(response.headers.fetch("Link", "")).next_link.try do |next_page|
            all(domain, next_page, depth - 1, headers, &block)
          end
          channel.send(nil)
        end

        JSON::PullParser.new(response.body).try do |pull|
          pull.read_begin_object

          pull.read_object_key
          pull.read_array do
            block.call self.from_json(pull.read_raw)
          end
        end

        channel.receive
      end
    end
  end

  macro creatable
    # Used to create one {{@type.id.split("::").last.downcase.id}}.
    #
    # Generally, this is used with `.with(store)`:
    # ```crystal
    # {{@type.id}}.with(store).create(body) #=> {{@type.id}}
    # ```
    # But it can be used stand-alone, too:
    #
    # ```crystal
    # {{@type.id}}.create(body, domain, headers: headers) #=> {{@type.id}}
    # ```
    # {% if @type == Shopify::Customer %}
    # A sample body from [shopify docs](https://shopify.dev/api/admin-rest/2022-01/resources/customer#post-customers):
    # ```json
    # {"customer":{"first_name":"Steve","last_name":"Lastnameson","email":"steve.lastnameson@example.com","phone":"+15142546011","verified_email":true,"addresses":[{"address1":"123 Oak St","city":"Ottawa","province":"ON","phone":"555-1212","zip":"123 ABC","last_name":"Lastnameson","first_name":"Mother","country":"CA"}]}}
    # ```
    # {% end %}
    # Under the covers, this just runs:
    # ```plaintext
    # POST
    # /admin/api/2022-01/{{@type.id.split("::").last.downcase.id}}s.json
    # ```
    def self.create(body : String, domain : String, headers : HTTP::Headers = headers) : {{@type.id}}
      JSON::PullParser.new(
        ErroringResponse.new(
          HTTP::Client.post(uri(domain), headers, body)
        ).body
      ).try do |pull|
        pull.read_begin_object
        pull.read_object_key

        from_json(pull.read_raw)
      end
    end
  end

  macro countable
    # Used to get a count of all {{@type.id.split("::").last.downcase.id}}s.
    #
    # Generally, this is used with `.with(store)`:
    # ```crystal
    # {{@type.id}}.with(store).count #=> Int64
    # ```
    # But it can be used stand-alone, too:
    #
    # ```crystal
    # {{@type.id}}.count(domain, headers: headers) #=> Int64
    # ```
    # Under the covers, this just runs:
    # ```plaintext
    # GET
    # /admin/api/2022-01/{{@type.id.split("::").last.downcase.id}}s/count.json
    # ```
    def self.count(domain : String, headers : HTTP::Headers = headers) : Int64
      JSON::PullParser.new(
        ErroringResponse.new(
          HTTP::Client.get(uri(domain, "/count"), headers)
        ).body
      ).try do |pull|
        pull.read_begin_object
        pull.read_object_key

        pull.read_int
      end
    end
  end

  macro searchable
    # Under the covers, this just runs:
    # ```plaintext
    # GET
    # /admin/api/2022-01/{{@type.id.split("::").last.downcase.id}}s/search.json?query=
    # ```
    def self.search(query : String, domain : String, headers : HTTP::Headers = headers)
      JSON::PullParser.new(
        ErroringResponse.new(
          HTTP::Client.get(
            uri(domain, "/search").tap &.query = "query=#{query}",
            headers
          )
        ).body
      ).try do |pull|
        pull.read_begin_object
        pull.read_object_key

        resources = [] of self
        pull.read_array do
          resources << from_json(pull.read_raw)
        end

        resources
      end
    end
  end

  macro updatable
    # {% if @type == Shopify::Customer %}
    # Sample Body from [Shopify Docs](https://shopify.dev/api/admin-rest/2022-01/resources/customer#put-customers-customer-id):
    # ```plaintext
    # {"id":207119551,"email":"changed@example.com","note":"Customer is great"}}
    # ```
    # {% end %}
    # Under the covers, this just runs:
    # ```plaintext
    # PUT
    # /admin/api/2022-01/{{@type.id.split("::").last.downcase.id}}s/{id}.json
    # ```
    def update(body : String) : self
      JSON::PullParser.new(
        ErroringResponse.new(
          HTTP::Client.put(
            self.class.uri(store.shop, "/#{id}"),
            HTTP::Headers{
              "X-Shopify-Access-Token" => store.access_token,
              "Content-Type"           => "application/json",
            },
            body
          )
        ).body
      ).try do |pull|
        pull.read_begin_object
        pull.read_object_key

        self.class.from_json pull.read_raw
      end
    end
  end

  macro deletable
    # Used to delete one {{@type.id.split("::").last.downcase.id}}.
    #
    # Under the covers, this just runs:
    # ```plaintext
    # DELETE
    # /admin/api/2022-01/{{@type.id.split("::").last.downcase.id}}s/{id}.json
    # ```
    def delete
      ErroringResponse.new(
        HTTP::Client.delete(
          self.class.uri(store.shop, "/#{id}"),
          HTTP::Headers{
            "X-Shopify-Access-Token" => store.access_token,
            "Content-Type"           => "application/json",
          }
        )
      )
    end
  end
end
