class JsonWebToken
  SECRET_KEY = ENV['JWT_SECRET']

  # Encodes the payload with an expiration time and secret key
  def self.encode(payload)
    # payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithms: 'HS256')[0]
    payload = HashWithIndifferentAccess.new(decoded)
    return User.find_by(id: payload[:id])
  rescue
    nil
  end
end
