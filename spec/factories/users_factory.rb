FactoryGirl.define do
  factory :user do
    login 'Test foo'
    password 'bar'
    password_confirmation 'bar'
  end
end
