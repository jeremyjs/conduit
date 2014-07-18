# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :complete_query do
    query_id 1
    variables "MyText"
    query_result "MyText"
    last_executed "2014-07-17 12:32:36"
  end
end
