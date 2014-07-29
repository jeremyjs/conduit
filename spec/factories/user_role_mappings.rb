# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_role_mapping do
    user_id 1
    role "MyString"
  end
end
