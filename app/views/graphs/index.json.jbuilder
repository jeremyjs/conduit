json.array!(@graphs) do |graph|
  json.extract! graph, :id, :query_id
  json.url graph_url(graph, format: :json)
end
