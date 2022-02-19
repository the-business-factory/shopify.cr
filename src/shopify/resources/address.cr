require "../../shopify"

@[JSON::Serializable::Options(emit_nulls: true)]
class Shopify::Address
  include JSON::Serializable
  property id : Int64
  property customer_id : Int64
  property first_name : String?
  property last_name : String?
  property company : String?
  property address1 : String?
  property address2 : String?
  property city : String
  property province : String
  property country : String
  property zip : String
  property phone : String?
  property name : String
  property province_code : String
  property country_code : String
  property country_name : String
  property default : Bool
end
