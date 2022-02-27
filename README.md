# shopify.cr

Crystal client for the Shopify API.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     shopify:
       github: the-business-factory/shopify.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "shopify"
```

1. Create App via [Shopify Partners](https://partners.shopify.com/)
1. Configure (defaults shown)

   ```crystal
   # config/shopify.cr
   Shopify.configure do |config|
     config.api_key = ENV["SHOPIFY_API_KEY"]
     config.secret = ENV["SHOPIFY_SECRET"]
     config.scope = "read_customers,write_customers,read_orders,write_orders,read_products,write_products"
     config.redirect_uri = "" # Required, String
   end
   ```

1. Use [Store helper](https://the-business-factory.github.io/shopify.cr/Shopify/Store.html)
   to get Store object, used later [Example](https://github.com/the-business-factory/shopify.cr/blob/main/script/get_access_token)
1. See Resource docs:

   - [Customer](https://the-business-factory.github.io/shopify.cr/Shopify/Customer.html)
   - [Order](https://the-business-factory.github.io/shopify.cr/Shopify/Order.html)
   - [Product](https://the-business-factory.github.io/shopify.cr/Shopify/Product.html)
   - [ProductVariant](https://the-business-factory.github.io/shopify.cr/Shopify/ProductVariant.html)

## Development

1. Clone this repository
1. `script/setup`
1. `crystal spec`
1. To use VCR to record new shopify requests, run `script/get_access_token` to get exports for shopify access tokens to pass into the `Shopify::Store`

## Contributing

1. Fork it (<https://github.com/the-business-factory/shopify/fork>)
2. Create your feature branch (`git checkout -b the-funnier-the-better`)
3. Commit your changes (`git commit -am 'Great commit message here'`)
4. Push to the branch (`git push origin the-funnier-the-better`)
5. Create a new Pull Request

## Contributors

- [Alex Piechowski](https://github.com/grepsedawk) - creator and maintainer
- [Rob Cole](https://github.com/robcole) - maintainer
