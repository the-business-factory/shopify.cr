require "../spec_helper"

Spectator.describe Shopify::ProductVariant do
  subject { Shopify::ProductVariant.from_json(raw_json) }
  let(raw_json) { File.read("spec/fixtures/product_variant.json") }
  let(store) do
    Shopify::Store.new(
      ENV.fetch("SHOPIFY_STORE", "example.myshopify.com"),
      ENV.fetch("SHOPIFY_ACCESS_TOKEN", "recorded")
    )
  end
  let(create_body) do
    <<-JSON
      {"variant":{"option1":"Yellow","price":"1.00"}}
      JSON
  end
  let(product) do
    Shopify::Product.with(store).create(
      {
        product: {
          title:        "Test Product",
          body_html:    "Test Product Body",
          product_type: "Test Product Type",
          vendor:       "Test Vendor",
          published:    true,
        },
      }.to_json
    )
  end

  it "should be able to initialize .from_json" do
    is_expected.to be_a(Shopify::ProductVariant)
  end

  it "should serialize and deserialze to the same object" do
    result = JSON.parse(subject.to_json)
    actual = JSON.parse(raw_json)

    expect(result.as_h.keys).to eq(actual.as_h.keys)
    expect(result).to eq actual
  end

  describe ".create" do
    it "does not fail" do
      VCR.use_cassette("product_variant_create") do
        Shopify::ProductVariant.with(store).create(create_body, product)
      end
    end
  end
end
