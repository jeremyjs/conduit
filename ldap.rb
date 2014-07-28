require 'net/ldap' # gem install net-ldap
#ldapsearch -b "ou=users,ou=corp,dc=enova,dc=com" -D "CN=Adpublic Nhu,OU=NHU,OU=Users,OU=CORP,DC=enova,DC=com" -H ldaps://adds.enova.com:636 -w lJgOQYEDBNQjcJ_gD^btKCGLXmDUy -v "uid=ntornquist"
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
email = 'nhandler@enova.com'
if ldap.bind
  puts ldap.search(
    base:         ldap_args[:base],
    filter:       Net::LDAP::Filter.eq( "mail", email ),
    attributes:   %w[ memberOf ],
    return_result:true
  ).first.memberof.to_a.inspect
end

