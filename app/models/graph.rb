class Graph < Widget
  belongs_to :query

  def value_hash(n = 1)
    n.times.map do
      {
        value: 100+rand(100),
        time: 1403808191
      }
    end
  end

  def color_array
    # "##{ 6.times.map { (('a'..'f').to_a + (0..9).to_a).sample }.join }"
    [
      "#556270",
      "#4ECDC4",
      "#C7F464",
      "#FF6B6B",
      "#C44D58",
    ]
  end

  def random_string(n = 1)
    n.times.map { ('a'..'z').to_a.sample }.join
  end

  def as_json(options = {})
    n = 5
    name_array = n.times.map { "name" + random_string(3) }
    type_array = ["bar", "line"]
    n.times.map do |i|
      vh = value_hash(10)
      type_array.map do |type|
        {
          name: "#{name_array[i]}_#{type}",
          values: vh,
          type: type,
          color: color_array[i],
          y2: true
        }
      end
    end.flatten
  end
end
