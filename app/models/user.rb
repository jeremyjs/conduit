class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :database_authenticatable ,  :rememberable, :trackable, :registerable, :validatable

  has_many :widgets


  before_validation(on: :create) do
    self.email ||= "#{self.login}@enova.com"
  end


end
