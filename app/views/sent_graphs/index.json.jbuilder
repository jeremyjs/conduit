json.array!(@sent_graphs) do |sent_graph|
  json.extract! sent_graph, :id
  json.url sent_graph_url(sent_graph, format: :json)
end
