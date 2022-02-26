require "habitat"
require "uri"
require "./shopify/resource"
require "./shopify/resources/**"
require "./shopify/auth/**"

module Shopify
  VERSION = "0.1.0"
  Habitat.create do
    setting api_key : String = ENV["SHOPIFY_API_KEY"]
    setting secret : String = ENV["SHOPIFY_SECRET"]
    setting scope : String = "read_customers,write_customers,read_orders,write_orders,read_products,write_products"
    setting redirect_uri : String
  end
end
