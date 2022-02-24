require "../../shopify"

@[JSON::Serializable::Options(emit_nulls: true)]
class Shopify::Order < Shopify::Resource
  indexable
  findable
  countable
  deletable
  creatable
  updatable

  def self.uri(domain : String, path : String = "") : URI
    URI.parse "https://#{domain}/admin/api/2022-01/orders#{path}.json"
  end

  property id : Int64

  # Under the covers, this just runs:
  # ```plaintext
  # POST
  # /admin/api/2022-01/orders/{id}/cancel.json
  # ```
  def cancel : self
    JSON::PullParser.new(
      HTTP::Client.post(
        self.class.uri(store.shop, "/#{id}/cancel"),
        HTTP::Headers{
          "X-Shopify-Access-Token" => store.access_token,
          "Content-Type"           => "application/json",
        },
        "{}"
      ).body
    ).try do |pull|
      pull.read_begin_object
      pull.read_object_key

      self.class.from_json(pull.read_raw).tap &.store=(store)
    end
  end

  # Under the covers, this just runs:
  # ```plaintext
  # POST
  # /admin/api/2022-01/orders/{id}/close.json
  # ```
  def close : self
    JSON::PullParser.new(
      HTTP::Client.post(
        self.class.uri(store.shop, "/#{id}/close"),
        HTTP::Headers{
          "X-Shopify-Access-Token" => store.access_token,
          "Content-Type"           => "application/json",
        },
        "{}"
      ).body
    ).try do |pull|
      pull.read_begin_object
      pull.read_object_key

      self.class.from_json(pull.read_raw).tap &.store=(store)
    end
  end

  # Under the covers, this just runs:
  # ```plaintext
  # POST
  # /admin/api/2022-01/orders/{id}/open.json
  # ```
  def open : self
    JSON::PullParser.new(
      HTTP::Client.post(
        self.class.uri(store.shop, "/#{id}/open"),
        HTTP::Headers{
          "X-Shopify-Access-Token" => store.access_token,
          "Content-Type"           => "application/json",
        },
        "{}"
      ).body
    ).try do |pull|
      pull.read_begin_object
      pull.read_object_key

      self.class.from_json(pull.read_raw).tap &.store=(store)
    end
  end
end
