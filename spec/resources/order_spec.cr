require "../spec_helper"

Spectator.describe Shopify::Order do
  subject { Shopify::Order.from_json(raw_json) }
  let(raw_json) { File.read("spec/fixtures/order.json") }

  it "should be able to initialize .from_json" do
    is_expected.to be_a(Shopify::Order)
  end

  it "should serialize and deserialze to the same object" do
    result = JSON.parse(subject.to_json)
    actual = JSON.parse(raw_json)

    expect(result.as_h.keys).to eq(actual.as_h.keys)
    expect(result).to eq actual
  end

  describe ".create" do
    let(store) do
      Shopify::Store.new(
        ENV.fetch("SHOPIFY_STORE", "example.myshopify.com"),
        ENV.fetch("SHOPIFY_ACCESS_TOKEN", "recorded")
      )
    end
    let(body) { {"order" => {"line_items" => [{"quantity" => 1, "price" => "10.00", "title" => "Test"}]}}.to_json }

    it "does not fail" do
      VCR.use_cassette("order_create") do
        Shopify::Order.with(store).create(body)
      end
    end
  end
end
