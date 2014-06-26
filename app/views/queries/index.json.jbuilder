json.array!(@queries) do |query|
  json.extract! query, :id, :command
  json.url query_url(query, format: :json)
end
