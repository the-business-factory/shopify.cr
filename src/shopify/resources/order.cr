require "../../shopify"

@[JSON::Serializable::Options(emit_nulls: true)]
class Shopify::Order < Shopify::Resource
  indexable
  countable
  deletable

  def self.uri(domain : String, path : String = "") : URI
    URI.parse "https://#{domain}/admin/api/2022-01/orders#{path}.json"
  end

  property id : Int64
end
