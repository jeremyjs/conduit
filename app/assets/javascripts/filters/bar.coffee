@barChartOptions = (chart, options = {}) ->
  $.extend true, options,
    data:
      type: 'bar'
    bar:
      width:
        ratio: chart['bar']['ratio']
        width: chart['bar']['width']
  options


