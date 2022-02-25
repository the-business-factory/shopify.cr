require "../spec_helper"

Spectator.describe Shopify::Collection do
  subject { Shopify::Collection.from_json(raw_json) }
  let(raw_json) { File.read("spec/fixtures/collection.json") }
  let(store) do
    Shopify::Store.new(
      ENV.fetch("SHOPIFY_STORE", "example.myshopify.com"),
      ENV.fetch("SHOPIFY_ACCESS_TOKEN", "recorded")
    )
  end
  let(irl_collection_id) { 391209124094 }

  it "should be able to initialize .from_json" do
    is_expected.to be_a(Shopify::Collection)
  end

  it "should serialize and deserialze to the same object" do
    result = JSON.parse(subject.to_json)
    actual = JSON.parse(raw_json)

    expect(result.as_h.keys).to eq(actual.as_h.keys)
    expect(result).to eq actual
  end

  describe ".find" do
    it "does not fail" do
      VCR.use_cassette("collection_find") do
        Shopify::Collection.with(store).find(irl_collection_id)
      end
    end
  end
end
