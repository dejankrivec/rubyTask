class User < ApplicationRecord

    #Validations
   validates_presence_of :username, :email, :password_digest
   validates :email, uniqueness: true

   has_secure_password
end
