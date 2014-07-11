class QueryTable < Widget
  belongs_to :query

  def rand_string
    "#{10000+rand(5000)}"
  end

  def as_json(options)
    {
      id: self.id,
      hide: ["provider", "nth_kpi"], 
      data: 10.times.map do
        {
          provider: "provider#{self.id}",
          first_kpi: rand_string,
          second_kpi: rand_string,
          third_kpi: rand_string,
          nth_kpi: rand_string
        }
      end
    }
  end
end
