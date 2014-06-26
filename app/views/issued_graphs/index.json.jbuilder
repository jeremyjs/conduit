json.array!(@issued_graphs) do |issued_graph|
  json.extract! issued_graph, :id
  json.url issued_graph_url(issued_graph, format: :json)
end
