require 'json_web_token'

class AuthorizeApiRequest
    prepend SimpleCommand

    def initialize(headers = {})
        @headers = headers
    end

    # The 'call' method is called from the AuthenticationController
    # in 'app/controllers/authentication_controller.rb'. This method
    # invokes a chain of three subsequent private methods:
    # 'user' => 'decoded_auth_toke' => 'http_auth_header'. 

    def call
        user
    end

    private
        attr_reader :headers

        # The 'user' method is called from the 'call' method and looks
        # for the requested user from the decoded JWT. If successful
        # @user is set to an instance of the correct user. In order to 
        # find the correct user the 'user' method calls the method 'decoded_auth_token'.

        def user
            @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
            @user ||= errors.add(:token, 'Invalid token', status: 406) && nil
        end

        # The 'decoded_auth_token' method calls the 'decode' method of the JsonWebToken
        # class defined in 'lib/json_web_token.rb'. If successful @decoded_auth_token
        # is defined as a HashWithIndifferentAccess, and if defined the 'user' method
        # will be successful. the 'JsonWebToken.decode' method takes the JWT, which
        # is retrieved in the 'http_auth_header' method. If @decoded_auth_token is
        # defined as 'nil', the user has provided an invalid token.

        def decoded_auth_token
            @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
        end

        # The 'http_auth_header' method is first checks to seed if a 'Authorization'
        # header was defined in the request headers. If so this method retrieves
        # the JWT from the 'Authorization' request header and returns it to the 
        # 'decoded_auth_token' method which in turns passes the JWT to the 
        # 'JsonWebToken.decode' method. If no 'Authorization' request header is 
        # present, the user has left out the JWT and will not be allowed access to
        # the requested data.

        def http_auth_header
            if headers['Authorization'].present?
                return headers['Authorization'].split(' ').last
            else
                errors.add(:token, 'Missing token', status: 405)
            end
            nil
        end
end