require "../src/shopify"
require "spectator"
require "vcr"

VCR.configure do |settings|
  settings.filter_sensitive_data["X-Shopify-Access-Token"] = "<ACCESS_TOKEN>"
end
