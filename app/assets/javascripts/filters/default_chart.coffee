@renderChart = (chart, options = {}) ->
  id = chart["id"]
  chart_data = chart["data"]
  chart =
    bindto: "#chart-#{id}"
    data:
      titles: getValsByAttr(chart_data, "name")
      columns: getColumns(chart_data)
      types: getValsByAttr(chart_data, "type")
    axis:
      y2:
        show: if chart["y2"] then true else false
    zoom:
      enabled: true
    color:
      pattern: ['#1f77b4', '#aec7e8', '#ff7f0e', '#ffbb78', '#2ca02c', '#98df8a', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']
  $.extend(true, chart, options)
  c3.generate(chart)

