require "../../shopify"

class Shopify::CustomerInvite
  include JSON::Serializable

  property to : String
  property from : String
  property subject : String
  property custom_message : String
  property bcc : Array(String)
end
