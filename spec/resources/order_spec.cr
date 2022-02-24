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

    pp! actual.as_h.keys - result.as_h.keys
    expect(result.as_h.keys).to eq(actual.as_h.keys)
    expect(result).to eq actual
  end
end
