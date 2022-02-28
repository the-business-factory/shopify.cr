require "../spec_helper"

Spectator.describe Shopify::Customer do
  subject { Shopify::Customer.from_json(raw_json) }
  let(raw_json) { File.read("spec/fixtures/customer.json") }
  let(store) do
    Shopify::Store.new(
      ENV.fetch("SHOPIFY_STORE", "example.myshopify.com"),
      ENV.fetch("SHOPIFY_ACCESS_TOKEN", "recorded")
    )
  end

  it "should be able to initialize from json" do
    is_expected.to be_a(Shopify::Customer)
  end

  it "should serialize and deserialze to the same object" do
    result = JSON.parse(subject.to_json)
    actual = JSON.parse(raw_json)

    expect(result.as_h.keys).to eq(actual.as_h.keys)
    expect(result).to eq actual
  end

  describe ".all" do
    it "should return a list of customers" do
      VCR.use_cassette("customer_all") do
        expect(Shopify::Customer.with(store).all).to be_a Array(Shopify::Customer)
      end
    end
  end
end
