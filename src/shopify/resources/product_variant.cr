@[JSON::Serializable::Options(emit_nulls: true)]
class Shopify::ProductVariant < Shopify::Resource
  def self.uri(domain : String, path : String = "", root_path = "/admin/api/2022-01/product_variants") : URI
    URI.parse "https://#{domain}#{root_path}#{path}.json"
  end

  property \
    barcode : String?,
    compare_at_price : String?,
    created_at : Time,
    fulfillment_service : String,
    grams : Int64,
    id : Int64,
    image_id : Int64?,
    inventory_item_id : Int64,
    inventory_management : String?,
    inventory_policy : String,
    inventory_quantity : Int64,
    old_inventory_quantity : Int64?,
    inventory_quantity_adjustment : Int64?,
    option : JSON::Any?,
    presentment_prices : JSON::Any?,
    position : Int64,
    price : (String | Float64),
    product_id : Int64,
    requires_shipping : Bool,
    sku : String,
    taxable : Bool,
    tax_code : String?,
    title : String,
    updated_at : Time,
    weight : Float64,
    weight_unit : String

  def self.create(
    body : String,
    domain : String,
    headers : HTTP::Headers,
    product_id : Int64
  ) : Shopify::ProductVariant
    JSON::PullParser.new(
      ErroringResponse.new(
        HTTP::Client.post(
          uri(domain, "/products/#{product_id}/variants", "/admin/api/2022-01"),
          headers,
          body
        )
      ).body
    ).try do |pull|
      pull.read_begin_object
      pull.read_object_key

      ProductVariant.from_json(pull.read_raw)
    end
  end

  def self.create(
    body : String,
    domain : String,
    headers : HTTP::Headers,
    product : Product
  ) : Shopify::ProductVariant
    create(body, domain, headers, product.id)
  end

  property \
    id : Int64
end
