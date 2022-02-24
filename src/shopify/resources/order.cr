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

  property \
    app_id : Int64,
    billing_address : JSON::Any,
    browser_ip : String,
    buyer_accepts_marketing : Bool,
    cancel_reason : String,
    cancelled_at : Time?,
    cart_token : String,
    checkout_token : String,
    client_details : JSON::Any,
    closed_at : Time?,
    created_at : Time,
    currency : String,
    current_total_discounts : String,
    current_total_discounts_set : JSON::Any,
    current_total_duties_set : JSON::Any,
    current_total_price : String,
    current_total_price_set : JSON::Any,
    current_subtotal_price : String,
    current_subtotal_price_set : JSON::Any,
    current_total_tax : String,
    current_total_tax_set : JSON::Any,
    customer : JSON::Any,
    customer_locale : String,
    discount_applications : JSON::Any,
    discount_codes : Array(JSON::Any),
    email : String,
    estimated_taxes : Bool,
    financial_status : String,
    fulfillments : Array(JSON::Any),
    fulfillment_status : String,
    gateway : String,
    id : Int64,
    landing_site : String,
    line_items : Array(JSON::Any),
    location_id : Int64,
    name : String,
    note : String,
    note_attributes : Array(Hash(String, String)),
    number : Int32,
    order_number : Int32,
    original_total_duties_set : JSON::Any,
    payment_details : Hash(String, String),
    payment_terms : JSON::Any,
    payment_gateway_names : Array(String),
    phone : String,
    presentment_currency : String,
    processed_at : Time?,
    processing_method : String,
    referring_site : String,
    refunds : Array(JSON::Any),
    shipping_address : JSON::Any,
    shipping_lines : Array(JSON::Any),
    source_name : String,
    subtotal_price : Int32,
    subtotal_price_set : JSON::Any,
    tags : String,
    tax_lines : Array(JSON::Any),
    taxes_included : Bool,
    test : Bool,
    token : String,
    total_discounts : String,
    total_discounts_set : JSON::Any,
    total_line_items_price : String,
    total_line_items_price_set : JSON::Any,
    total_outstanding : String,
    total_price : String,
    total_price_set : JSON::Any,
    total_shipping_price_set : JSON::Any,
    total_tax : String,
    total_tax_set : JSON::Any,
    total_tip_received : String,
    total_weight : Int32,
    updated_at : Time,
    user_id : Int64,
    order_status_url : Hash(String, String)

  # Under the covers, this just runs:
  # ```plaintext
  # POST
  # /admin/api/2022-01/orders/{id}/cancel.json
  # ```
  def cancel : self
    JSON::PullParser.new(
      ErroringResponse.new(
        HTTP::Client.post(
          self.class.uri(store.shop, "/#{id}/cancel"),
          HTTP::Headers{
            "X-Shopify-Access-Token" => store.access_token,
            "Content-Type"           => "application/json",
          },
          "{}"
        )
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
      ErroringResponse.new(
        HTTP::Client.post(
          self.class.uri(store.shop, "/#{id}/close"),
          HTTP::Headers{
            "X-Shopify-Access-Token" => store.access_token,
            "Content-Type"           => "application/json",
          },
          "{}"
        )
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
      ErroringResponse.new(
        HTTP::Client.post(
          self.class.uri(store.shop, "/#{id}/open"),
          HTTP::Headers{
            "X-Shopify-Access-Token" => store.access_token,
            "Content-Type"           => "application/json",
          },
          "{}"
        )
      ).body
    ).try do |pull|
      pull.read_begin_object
      pull.read_object_key

      self.class.from_json(pull.read_raw).tap &.store=(store)
    end
  end
end
