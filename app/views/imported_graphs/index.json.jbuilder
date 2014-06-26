json.array!(@imported_graphs) do |imported_graph|
  json.extract! imported_graph, :id
  json.url imported_graph_url(imported_graph, format: :json)
end
