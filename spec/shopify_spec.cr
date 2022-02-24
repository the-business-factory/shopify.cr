require "./spec_helper"

Spectator.describe Shopify do
  it "can be configured" do
    Shopify.configure do |config|
      config.api_key = "my_api_key"
      config.secret = "my_secret"
      config.scope = "read_products,write_products"
      config.redirect_uri = "http://localhost:3000/auth/shopify/callback"
    end

    expect(Shopify.settings.api_key).to eq "my_api_key"
    expect(Shopify.settings.secret).to eq "my_secret"
    expect(Shopify.settings.scope).to eq "read_products,write_products"
    expect(Shopify.settings.redirect_uri).to eq "http://localhost:3000/auth/shopify/callback"
  end
end
