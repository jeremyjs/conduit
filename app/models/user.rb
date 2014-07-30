class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :database_authenticatable ,  :rememberable, :trackable, :registerable, :validatable

  has_many :widgets
  has_many :user_role_mappings


  before_validation(on: :create) do
    self.email ||= "#{self.login}@enova.com"
  end

  def update_roles
    self.roles = []
    if self.email.ends_with?('@enova.com')
      if not self.left_company?
        ldap_groups_to_roles
        user_to_roles
      end
    else
      user_to_roles
    end
  end

  def left_company?
    employee_type = get_employee_type
    (type, date) = employee_type.split('-', 2)
    return type == "NLE" && date <= DateTime.now
  end

  def self.enova_users
    self.where("email LIKE (?)", "%@enova.com")
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

  def user_to_roles
    UserRoleMapping.where(user: self).each do |mapping|
      self.add_role(mapping.role)
    end
  end

  def ldap_groups_to_roles
    groups = get_ldap_groups
    LdapRoleMapping.all.each do |mapping|
      if groups.include?(mapping.ldap_group)
        self.add_role(mapping.role)
      end
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

  def get_employee_type
    ldap = get_ldap

    ldap.search(
      base:         ldap.base,
      filter:       Net::LDAP::Filter.eq( "uid", self.login ),
      attributes:   %w[ employeeType ],
      return_result:true
    ).first.employeeType.first
  end
end
