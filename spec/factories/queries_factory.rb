FactoryGirl.define do
    factory :query do
      command 'SELECT id FROM customers LIMIT %{customers}'
    end
end
