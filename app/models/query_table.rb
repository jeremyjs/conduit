class QueryTable < Widget
  belongs_to :query
  def as_json(options)
    {
      id: self.id,
      data: [
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        },
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        },
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        },
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        },
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        },
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        },
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        },
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        },
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        },
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        },
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        },
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        },
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        },
        {
          provider: "provider#{self.id}",
          first_kpi: "#{10000+rand(5000)}",
          second_kpi: "#{5000+rand(2500)}",
          third_kpi: "#{7000+rand(8500)}",
          nth_kpi: "#{8000+rand(2100)}"
        }
      ]
    }
  end
end
