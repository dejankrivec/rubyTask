class JsonWebToken
    # our secret key to encode our jwt
    
    class << self
        def encode(payload, exp = 2.hours.from_now)
            # token expiration
            payload[:exp] = exp.to_i
            # encode data
            JWT.encode(payload, Rails.application.secret_key_base)
        end
    
        def decode(token)
            #decode data
            Rails.logger.debug("decoding")
            body = JWT.decode(token, Rails.application.secret_key_base)[0]
            Rails.logger.debug("decoded")

            HashWithIndifferentAccess.new body
    
        # error handler
            rescue JWT::ExpiredSignature, JWT::VerificationError => e
                raise ExceptionHandler::ExpiredSignature, e.message
            rescue JWT::DecodeError, JWT::VerificationError => e
                raise ExceptionHandler::DecodeError, e.message
        end
    end
end