class Graph < Widget
  def as_json(options)
    [
      {
        name: "DescriptiveQueryName",
        values: [
          {
            value: 42,
            time: 1403808191
          },
          {
            value: 75,
            time: 1403808440
          },
          {
            value: 25,
            time: 1403808458
          }
        ],
        type: "bar"
      },
      {
        name: "DescriptiveQueryName2",
        values: [
          {
            value: 63,
            time: 1403808191
          },
          {
            value: 33,
            time: 1403808440
          },
          {
            value: 93,
            time: 1403808458
          }
        ],
        type: "line"
      }
    ]
  end
end
