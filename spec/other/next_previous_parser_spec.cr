require "../spec_helper"

Spectator.describe Shopify::Resource::NextPreviousParser do
  subject { Shopify::Resource::NextPreviousParser.new(link_header) }
  let(link_header) { nil }

  describe "#next_link" do
    context "when there is a next link" do
      let(:link_header) { "</next-link>; rel=\"next\"" }

      it "returns the next page" do
        expect(subject.next_link).to eq("/next-link")
      end
    end

    context "when there is no next link" do
      let(:link_header) { "</prev>; rel=\"prev\"" }

      it "returns nil" do
        expect(subject.next_link).to be_nil
      end
    end
  end
end
