class Shopify::WithStore(TResource)
  def initialize(@store : Store); end

  def new_headers
    HTTP::Headers{
      "X-Shopify-Access-Token" => @store.access_token,
      "Content-Type"           => "application/json",
    }
  end

  forward_missing_to TResource

  def all
    TResource.all(@store.shop, new_headers).map &.tap(&.store=(@store))
  end

  def all(page : String? = nil, &block : TResource ->)
    TResource.all(@store.shop, page, new_headers) do |resource|
      block.call(resource.tap(&.store=(@store)))
    end
  end

  def find(id)
    TResource.find(id, @store.shop, new_headers).tap &.store=(@store)
  end

  def create(body : String, *args)
    TResource.create(body, @store.shop, new_headers, *args).tap &.store=(@store)
  end

  def search(query : String)
    TResource.search(query, @store.shop, new_headers).map &.tap(&.store=(@store))
  end

  def count
    TResource.count(@store.shop, new_headers)
  end
end
