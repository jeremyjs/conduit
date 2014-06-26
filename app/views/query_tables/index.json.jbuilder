json.array!(@query_tables) do |query_table|
  json.extract! query_table, :id, :query_id
  json.url query_table_url(query_table, format: :json)
end
