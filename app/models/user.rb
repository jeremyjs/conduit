class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :database_authenticatable ,  :rememberable, :trackable, :registerable


  validates_presence_of   :password, :on=>:create
   validates_confirmation_of   :password, :on=>:create
    validates_length_of :password, :within => Devise.password_length
end
