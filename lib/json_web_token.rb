# Class and methods used from the 'jwt' gem.

class JsonWebToken
     class << self 

        # The 'encode' method is called from the 'call' method in the 'AuthenticateUser' class
        # defined in 'app/commands/authenticate_user.rb'. The method takes the 'payload' 
        # parameter which is the valid user's user_id. The encoded JWT is created using the 
        # 'jwt' gem's 'encode' method which encodes the JWT with the user_id, expiration_time,
        # and the secret_key_base. The JWT is then returned to 'AuthorizeUser.call' method, which
        # returns the JWT to the 'AuthenticateUser.authenticate' method, which gives the validated
        # user their encoded JWT. This encoded JWT is passed in every subsequent request through
        # the 'Authorization' request header. If the JWT matches the server's JWT the request will
        # accepted and the requested data will be sent to the user in JSON format.

        def encode(payload, exp = 1.hours.from_now) 
            payload[:exp] = exp.to_i 
            JWT.encode(payload, Rails.application.secrets.secret_key_base) 
        end 

        # The 'decode' method is called from the 'decoded_auth_token' method
        # in the AuthorizedApiRequest class defined in 'app/commands/authorize_api_requests.rb'
        # The method takes the 'token' parameter provided by the user from the 
        # 'Authorization' request header. The 'token' is decoded using the 
        # 'jwt' gem's 'decode' method which takes the 'token' and the secret_key_base
        # which is used to encode the JWT initially. This creates a HashWithIndifferentAccess
        # from the decoded JWT and returns it to the 'decoded_auth_tokem' method.
        # The method will return 'nil' if no JWT was specified in the 'Authorization' request header.

        def decode(token)
            body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0] 
            HashWithIndifferentAccess.new body 
        rescue => error
        end 
    end 
end