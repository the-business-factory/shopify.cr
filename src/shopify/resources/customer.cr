require "../../shopify"

# [https://shopify.dev/api/admin-rest/2022-01/resources/customer](https://shopify.dev/api/admin-rest/2022-01/resources/customer)
@[JSON::Serializable::Options(emit_nulls: true)]
class Shopify::Customer < Shopify::Resource
  findable
  indexable
  creatable
  countable

  @[JSON::Field(ignore: true)]
  property store : Store = Store.new("unknown.myshopify.com")

  property id : Int64
  property email : String
  property accepts_marketing : Bool
  property created_at : Time
  property updated_at : Time
  property first_name : String
  property last_name : String
  property orders_count : Int32
  property state : String
  property total_spent : String
  property last_order_id : Int64?
  property note : String?
  property verified_email : Bool
  property multipass_identifier : String?
  property tax_exempt : Bool
  property phone : String?
  property tags : String
  property last_order_name : String?
  property currency : String
  property addresses : Array(Shopify::Address)
  property accepts_marketing_updated_at : Time
  property marketing_opt_in_level : String?
  property tax_exemptions : Array(JSON::Any)
  property sms_marketing_consent : JSON::Any?
  property admin_graphql_api_id : String
  property default_address : Shopify::Address

  def self.uri(domain : String, path : String = "") : URI
    URI.parse "https://#{domain}/admin/api/2022-01/customers#{path}.json"
  end

  # Under the covers, this just runs:
  # ```plaintext
  # POST
  # /admin/api/2022-01/customers/{id}/account_activation_url.json
  # ```
  def create_account_activation_url : URI
    JSON::PullParser.new(
      HTTP::Client.post(
        self.class.uri(store.shop, "/#{id}/account_activation_url"),
        HTTP::Headers{
          "X-Shopify-Access-Token" => store.access_token,
          "Content-Type"           => "application/json",
        },
        "{}"
      ).body
    ).try do |pull|
      pull.read_begin_object
      pull.read_object_key

      URI.parse pull.read_string
    end
  end

  # Under the covers, this just runs:
  # ```plaintext
  # POST
  # /admin/api/2022-01/customers/{id}/send_invite.json
  # ```
  def send_invite : Shopify::CustomerInvite
    JSON::PullParser.new(
      HTTP::Client.post(
        self.class.uri(store.shop, "/#{id}/send_invite"),
        HTTP::Headers{
          "X-Shopify-Access-Token" => store.access_token,
          "Content-Type"           => "application/json",
        },
        "{\"customer_invite\":{}}"
      ).body
    ).try do |pull|
      pull.read_begin_object
      pull.read_object_key

      CustomerInvite.from_json pull.read_raw
    end
  end

  # Under the covers, this just runs:
  # ```plaintext
  # GET
  # /admin/api/2022-01/customers/{id}/orders.json
  # ```
  def orders : Array(Shopify::Order)
    JSON::PullParser.new(
      pp! HTTP::Client.get(
        self.class.uri(store.shop, "/#{id}/orders"),
        HTTP::Headers{
          "X-Shopify-Access-Token" => store.access_token,
          "Content-Type"           => "application/json",
        }
      ).body
    ).try do |pull|
      pull.read_begin_object
      pull.read_object_key

      orders = [] of Shopify::Order
      pull.read_array do
        orders << Order.from_json pull.read_raw
      end

      orders
    end
  end

  # Under the covers, this just runs:
  # ```plaintext
  # PUT
  # /admin/api/2022-01/customers/{id}.json
  # ```
  def update(body : String) : Shopify::Customer
    JSON::PullParser.new(
      pp! HTTP::Client.put(
        self.class.uri(store.shop, "/#{id}"),
        HTTP::Headers{
          "X-Shopify-Access-Token" => store.access_token,
          "Content-Type"           => "application/json",
        },
        body
      ).body
    ).try do |pull|
      pull.read_begin_object
      pull.read_object_key

      Customer.from_json pull.read_raw
    end
  end

  # Under the covers, this just runs:
  # ```plaintext
  # DELETE
  # /admin/api/2022-01/customers/{id}.json
  # ```
  def delete
    HTTP::Client.delete(
      self.class.uri(store.shop, "/#{id}"),
      HTTP::Headers{
        "X-Shopify-Access-Token" => store.access_token,
        "Content-Type"           => "application/json",
      }
    )
  end
end
