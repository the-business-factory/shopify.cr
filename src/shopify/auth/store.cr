class Shopify::Store
  property shop : String
  property access_token : String?
  property hmac : String?
  property code : String?
  property timestamp : String?

  def initialize(@shop, @access_token = nil, @hmac = nil, @code = nil, @timestamp = nil)
  end

  def self.from_params(params)
    new(
      hmac: params["hmac"],
      shop: params["shop"],
      timestamp: params["timestamp"],
      code: params["code"]?,
    )
  end

  def access_token
    @access_token ||= retrieve_access_token
  end

  class Shopify::MissingAccessCode < Exception; end

  def retrieve_access_token : String
    response = HTTP::Client.post(
      "https://#{shop}/admin/oauth/access_token",
      form: {
        "client_id"     => Shopify.settings.api_key,
        "client_secret" => Shopify.settings.secret,
        "code"          => code.presence || raise Shopify::MissingAccessCode.new,
      }
    )

    JSON.parse(response.body)["access_token"].as_s
  end

  def oauth_url
    "https://#{shop}/admin/oauth/authorize?client_id=#{Shopify.settings.api_key}&scope=#{Shopify.settings.scope}&redirect_uri=#{Shopify.settings.redirect_uri}"
  end
end
