class Graph < Widget
  belongs_to :query
  def as_json(options)
    [
      {
        name: "DescriptiveQueryName",
        values: [
          {
            value: 100+rand(100),
            time: 1403808191
          },
          {
            value: 75+rand(50),
            time: 1403808440
          },
          {
            value: 25+rand(75),
            time: 1403808458
          }
        ],
        type: "bar"
      },
      {
        name: "DescriptiveQueryName2",
        values: [
          {
            value: 63+rand(120),
            time: 1403808191
          },
          {
            value: 33+rand(122),
            time: 1403808440
          },
          {
            value: 93+rand(123),
            time: 1403808458
          }
        ],
        type: "line"
      }
    ]
  end
end
