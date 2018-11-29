require "#{Rails.root}/lib/json_jwt_token.rb"

class AuthenticateUser
    prepend SimpleCommand
    attr_accessor :email, :password
  
    #set parameters when command is called
    def initialize(email, password)
      @email = email
      @password = password
    end
    
    # generate token
    def call
        JsonWebToken.encode(user_id: user.id) if user
    end
  
    private
    def user
        user = User.where(:email => email).first

        return user if user && user.authenticate(password)
        errors.add :user_authentication, 'Invalid credentials'
        nil
    end
  end