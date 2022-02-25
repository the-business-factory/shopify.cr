@[JSON::Serializable::Options(emit_nulls: true)]
class Shopify::Product < Shopify::Resource
  creatable
  indexable
  findable
  countable
  updatable
  deletable

  def self.uri(domain : String, path : String = "") : URI
    URI.parse "https://#{domain}/admin/api/2021-10/products#{path}.json"
  end

  property \
    body_html : String,
    created_at : Time,
    handle : String,
    id : Int64,
    images : Array(JSON::Any),
    options : JSON::Any,
    product_type : String,
    published_at : Time?,
    published_scope : String,
    status : String,
    tags : String,
    template_suffix : String?,
    title : String,
    updated_at : Time,
    variants : Array(JSON::Any),
    vendor : String

  def create_product_variant(body : String) : Shopify::ProductVariant
    Shopify::ProductVariant.create(
      id,
      body,
      store.shop,
      HTTP::Headers{
        "X-Shopify-Access-Token" => store.access_token,
        "Content-Type"           => "application/json",
      },
    )
  end
end
