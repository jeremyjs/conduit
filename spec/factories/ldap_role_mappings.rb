# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ldap_role_mapping do
    ldap_group "MyString"
    role "MyString"
  end
end
