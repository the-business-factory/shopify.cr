require "../../shopify"

@[JSON::Serializable::Options(emit_nulls: true)]
class Shopify::Collection < Shopify::Resource
  findable

  def self.uri(domain : String, path : String = "") : URI
    URI.parse "https://#{domain}/admin/api/2021-10/collections#{path}.json"
  end

  property \
    body_html : String?,
    handle : String,
    image : JSON::Any?,
    id : Int64,
    published_at : Time?,
    published_scope : String,
    sort_order : String,
    template_suffix : String?,
    title : String,
    updated_at : Time
end
