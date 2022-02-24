require "../shopify"
require "json"
require "http/client"

abstract class Shopify::Resource
  include JSON::Serializable

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
    def self.find(id : Int64, domain : String, headers : HTTP::Headers = headers)
      JSON::PullParser.new(
        HTTP::Client.get(uri(domain, "/#{id}"), headers).body
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
    # Generally, this is used with `.with(store)`:
    # ```crystal
    # {{@type.id}}.with(store).all #=> Array({{@type.id}})
    # ```
    # But it can be used stand-alone, too:
    #
    # ```crystal
    # {{@type.id}}.all(domain, headers: headers) #=> Array({{@type.id}})
    # ```
    def self.all(domain : String, headers : HTTP::Headers = headers)
      resources = [] of self

      all(domain, headers: headers) do |resource|
        resources << resource
      end

      resources
    end

    # Used to iterate over all {{@type.id.split("::").last.downcase.id}}s. Uses fibers to fetch pages concurrently.
    #
    # Generally, this is used with `.with(store)`:
    # ```crystal
    # {{@type.id}}.with(store).all do |customer|
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
    def self.all(
      domain : String,
      next_page_uri : String? = nil,
      headers : HTTP::Headers = headers,
      &block : self ->
    )
      HTTP::Client.get(
        next_page_uri || uri(domain),
        headers
      ).try do |response|
        channel = Channel(Nil).new
        spawn do
          NextPreviousParser.new(response.headers["Link"]).next_link.try do |next_page|
            all(domain, next_page, headers, &block)
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

  macro inherited
    extend ClassMethods

    def self.with(store : Store)
      WithStore(self).new(store)
    end
  end
end
