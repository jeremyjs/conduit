json.array!(@widgets) do |widget|
  json.extract! widget, :id, :name, :row, :column, :width, :height
  json.url widget_url(widget, format: :json)
end
