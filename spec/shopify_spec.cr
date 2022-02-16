require "./spec_helper"

describe Shopify do
  it "can be configured" do
    Shopify.configure do |config|
      config.api_key = "my_api_key"
      config.secret = "my_secret"
      config.scope = "read_products,write_products"
      config.redirect_uri = "http://localhost:3000/auth/shopify/callback"
    end

    Shopify.settings.api_key.should eq "my_api_key"
    Shopify.settings.secret.should eq "my_secret"
    Shopify.settings.scope.should eq "read_products,write_products"
    Shopify.settings.redirect_uri.should eq "http://localhost:3000/auth/shopify/callback"
  end
end
