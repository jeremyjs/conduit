class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :database_authenticatable ,  :rememberable, :trackable, :registerable, :validatable


  before_validation(on: :create) do
    self.email ||= "#{self.login}@enova.com"
  end


end
