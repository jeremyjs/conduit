json.array!(@widgets) do |widget|
  json.extract! widget, :id, :name, :data
  json.url widget_url(widget, format: :json)
end
