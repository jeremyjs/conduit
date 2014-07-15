@renderChart = (id) ->
  id = id[1] if id[0] == '#'
  chart_data = getChartData(id)
  chart =
    bindto: "#chart-#{id}"
    data:
      titles: getTitles(chart_data)
      columns: getColumns(chart_data)
      types: getTypes(chart_data)
      colors: getColors(chart_data)
    axis:
      y2:
        show: if chart_data[0]["y2"] then true else false
    zoom:
      enabled: true
  c3.generate(chart)
