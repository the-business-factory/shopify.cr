require "../../shopify"

# [https://shopify.dev/api/admin-rest/2022-01/resources/customer](https://shopify.dev/api/admin-rest/2022-01/resources/customer)
@[JSON::Serializable::Options(emit_nulls: true)]
class Shopify::Customer < Shopify::Resource
  property id : Int64
  property email : String
  property accepts_marketing : Bool
  property created_at : Time
  property updated_at : Time
  property first_name : String
  property last_name : String
  property orders_count : Int32
  property state : String
  property total_spent : String
  property last_order_id : Int64?
  property note : String?
  property verified_email : Bool
  property multipass_identifier : String?
  property tax_exempt : Bool
  property phone : String?
  property tags : String
  property last_order_name : String?
  property currency : String
  property addresses : Array(Shopify::Address)
  property accepts_marketing_updated_at : Time
  property marketing_opt_in_level : String?
  property tax_exemptions : Array(JSON::Any)
  property sms_marketing_consent : String?
  property admin_graphql_api_id : String
  property default_address : Shopify::Address

  def self.uri(domain : String, path : String = "") : URI
    URI.parse "https://#{domain}/admin/api/2022-01/customers#{path}.json"
  end
end
