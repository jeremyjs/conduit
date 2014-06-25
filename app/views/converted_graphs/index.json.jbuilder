json.array!(@converted_graphs) do |converted_graph|
  json.extract! converted_graph, :id
  json.url converted_graph_url(converted_graph, format: :json)
end
