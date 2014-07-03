json.array!(@pages) do |page|
  json.extract! page, :id, :title, :number
  json.url page_url(page, format: :json)
end
