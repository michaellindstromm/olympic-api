require 'json_web_token'

class AuthenticateUser
    prepend SimpleCommand

    def initialize(email, password)
        @email = email
        @password = password
    end

    # The 'call' method is called from the 'authenticate' method
    # in the 'AuthenticationController' class defined in 
    # 'app/controllers/authentication_controller.rb'. This method
    # calls the 'encode' method in the 'JsonWebToken' class defined
    # in 'lib/json_web_token.rb' if the 'user' method returns a user
    # based on the 'email' and 'password' provided.

    def call
        JsonWebToken.encode(user_id: user.id) if user
    end

    private
        attr_accessor :email, :password

        # The 'user' method returns a user if the supplied email and
        # password are valid. Otherwise the 'user' method returns nil
        # and the JWT is never supplied to the potential user. If 
        # successful the 'call' method can then call the 'encode' mehtod
        # in the 'JsonWebToken' class.

        def user
            user = User.find_by_email(email)
            return user if user && user.authenticate(password)

            errors.add :user_authentication, 'invalid credentials', status: 403
            nil
        end
end