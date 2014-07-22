FactoryGirl.define do
  factory :graph do
    query_id 3
    variables {{:start_time => "2013-05-26 00:00:00", end_time: "2013-06-02 23:59:59", providers: "'t3uk'"}}
  end
end
