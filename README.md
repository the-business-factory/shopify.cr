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

TODO: Write usage instructions here

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
