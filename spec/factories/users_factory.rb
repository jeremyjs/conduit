FactoryGirl.define do
  factory :user do
    email 'foo@bar.com'
    login 'Test foo'
    password 'bar'
    password_confirmation 'bar'
  end
end
