class JsonWebToken
  # Secret key for encoding and decoding the token (using Rails credentials)
  SECRET_KEY = Rails.application.credentials.secret_key_base

  # Encodes the payload with an expiration time and secret key
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # Decodes the token and returns the decoded data (if valid)
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    nil
  end
end
