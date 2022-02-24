require "../spec_helper"

Spectator.describe Shopify::Product do
  subject { Shopify::Product.from_json(raw_json) }
  let(raw_json) { File.read("spec/fixtures/product.json") }
  let(store) do
    Shopify::Store.new(
      ENV.fetch("SHOPIFY_STORE", "example.myshopify.com"),
      ENV.fetch("SHOPIFY_ACCESS_TOKEN", "recorded")
    )
  end
  let(create_body) do
    <<-JSON
      {"product":{"title":"Burton Custom Freestyle 151","body_html":"\u003cstrong\u003eGood snowboard!\u003c/strong\u003e","vendor":"Burton","product_type":"Snowboard","tags":["Barnes \u0026 Noble","Big Air","John's Fav"]}}
      JSON
  end

  it "should be able to initialize .from_json" do
    is_expected.to be_a(Shopify::Product)
  end

  it "should serialize and deserialze to the same object" do
    result = JSON.parse(subject.to_json)
    actual = JSON.parse(raw_json)

    expect(result.as_h.keys).to eq(actual.as_h.keys)
    expect(result).to eq actual
  end

  describe ".create" do
    it "does not fail" do
      VCR.use_cassette("product_create") do
        Shopify::Product.with(store).create(create_body)
      end
    end
  end

  describe ".all" do
    it "does not fail" do
      VCR.use_cassette("product_all") do
        Shopify::Product.with(store).all
      end
    end
  end

  describe ".find" do
    it "does not fail" do
      VCR.use_cassette("product_find") do
        Shopify::Product.with(store).try do |products|
          products.find(products.create(create_body).id)
        end
      end
    end
  end

  describe ".count" do
    it "does not fail" do
      VCR.use_cassette("product_count") do
        Shopify::Product.with(store).try do |products|
          products.create(create_body)
          expect(products.count).to be > 0
        end
      end
    end
  end

  describe "#update" do
    it "does not fail" do
      VCR.use_cassette("product_updated") do
        Shopify::Product.with(store)
          .create(create_body)
          .update({"product" => {"title" => "New Title"}}.to_json)
      end
    end
  end

  describe "#delete" do
    it "does not fail" do
      VCR.use_cassette("product_deleted") do
        Shopify::Product.with(store).create(create_body).try do |product|
          product.delete
          expect {
            Shopify::Product.with(store).find(product.id)
          }.to raise_error(Shopify::ResourceNotFound)
        end
      end
    end
  end
end
