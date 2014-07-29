class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :database_authenticatable ,  :rememberable, :trackable, :registerable, :validatable

  has_many :widgets


  before_validation(on: :create) do
    self.email ||= "#{self.login}@enova.com"
  end

  def ldap_groups_to_roles
    groups = get_ldap_groups
    self.roles = []
    if groups.include?("CN=R&D - Dev,OU=Departments,OU=Groups,OU=CORP,DC=enova,DC=com")
      self.add_role("admin")
    end
  end

  def get_ldap_groups
    ldap = get_ldap

    ldap.search(
      base:         ldap.base,
      filter:       Net::LDAP::Filter.eq( "uid", self.login ),
      attributes:   %w[ memberOf ],
      return_result:true
    ).first.memberof.to_a
  end

  private
  def get_ldap
    ldap_args = {}
    ldap_args[:host] = 'adds.enova.com'
    ldap_args[:base] = 'ou=users,ou=corp,dc=enova,dc=com'
    ldap_args[:encryption] = :simple_tls
    ldap_args[:port] = 636

    auth = {}
    auth[:username] = 'CN=Adpublic Nhu,OU=NHU,OU=Users,OU=CORP,DC=enova,DC=com'
    auth[:password] = 'lJgOQYEDBNQjcJ_gD^btKCGLXmDUy'
    auth[:method] = :simple
    ldap_args[:auth] = auth

    ldap = Net::LDAP.new(ldap_args)
  end
end
