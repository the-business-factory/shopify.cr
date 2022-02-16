require "habitat"

module Shopify
  VERSION = "0.1.0"

  Habitat.create do
    setting api_key : String
    setting secret : String
    setting scope : String
    setting redirect_uri : String
  end
end
