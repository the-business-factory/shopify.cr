class Shopify::AuthenticationError < Exception; end

class Shopify::PermissionDenied < Exception; end

class Shopify::ResourceNotFound < Exception; end

class Shopify::ValidationError < Exception; end

class Shopify::TooManyRequests < Exception; end

class Shopify::InternalServerError < Exception; end

class Shopify::ServiceUnavailable < Exception; end

# Decorates the HTTP::Client::Response and provides raised exceptions when the
# response status_code is not successful.
class Shopify::ErroringResponse
  def initialize(@response : HTTP::Client::Response)
    pp! response
    case response.status_code
    when 401
      raise Shopify::AuthenticationError.new(response.body)
    when 403
      raise Shopify::PermissionDenied.new(response.body)
    when 404
      raise Shopify::ResourceNotFound.new(response.body)
    when 422
      raise Shopify::ValidationError.new(response.body)
    when 429
      raise Shopify::TooManyRequests.new(response.body)
    when 500
      raise Shopify::InternalServerError.new(response.body)
    when 503
      raise Shopify::ServiceUnavailable.new(response.body)
    end
  end

  forward_missing_to @response
end
