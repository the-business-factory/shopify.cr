require "../spec_helper"

Spectator.describe Shopify::SmartCollection do
  subject { Shopify::SmartCollection.from_json(raw_json) }
  let(raw_json) { File.read("spec/fixtures/collection.json") }
  let(store) do
    Shopify::Store.new(
      ENV.fetch("SHOPIFY_STORE", "example.myshopify.com"),
      ENV.fetch("SHOPIFY_ACCESS_TOKEN", "recorded")
    )
  end
  let(create_body) do
    {
      "smart_collection" => {
        "title" => "My Smart Collection",
        "rules" => [
          {
            "column"    => "title",
            "relation"  => "contains",
            "condition" => "shirt",
          },
        ],
      },
    }.to_json
  end

  it "should be able to initialize .from_json" do
    is_expected.to be_a(Shopify::SmartCollection)
  end

  it "should serialize and deserialze to the same object" do
    result = JSON.parse(subject.to_json)
    actual = JSON.parse(raw_json)

    expect(result.as_h.keys).to eq(actual.as_h.keys)
    expect(result).to eq actual
  end

  describe ".create" do
    it "should create a new smart collection" do
      VCR.use_cassette("smart_collection_create") do
        expect(Shopify::SmartCollection.with(store).create(create_body)).to be_a(Shopify::SmartCollection)
      end
    end
  end

  describe ".find" do
    it "does not fail" do
      VCR.use_cassette("smart_collection_find") do
        Shopify::SmartCollection.with(store).try do |smart_collections|
          smart_collections.find(smart_collections.create(create_body).id)
        end
      end
    end
  end
end
