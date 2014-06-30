window.charts = []

@ajax2Chart = (num) ->
  globalData = null
  $.get "/graphs/#{num}.json", (data) ->
    globalData = data
  console.info(globalData)
  datas = []
  titles = {}
  typing = {}
  for graph in globalData
    titles[graph.name] = graph.name
    typing[graph.name] = graph.type

    col_vals = (val.value for val in graph.values)
    col_vals.unshift(graph.name)
    datas.push(col_vals)
  {
    bindto: "#chart-#{num}"
    data: {
      columns: datas
      axes: {
        DescriptiveQueryName: 'y'
        DescriptiveQueryName2: 'y2'
      }
      types: typing
    }
    axis: {
      y2: {
        show: true
      }
    }
  }

@drawWidgets = ->
  for name, chart of window.charts
    @drawChart(name, chart)

# can also use like @drawChart(name)
@drawChart = (name, chart) ->
  chart = window.charts[name] unless chart
  $chart_elem = $(name)
  new_height = calculateHeight($chart_elem)
  chart.resize({height: new_height})

calculateHeight = ($chart) ->
  $parent = $chart.parents('.grid-item').first()
  $panel = $parent.find('.panel-body')
  $panel_header = $parent.find('.panel-heading')

  parent_height = $parent.height()
  header_height = $panel_header.outerHeight()
  panel_padding_height = $panel.outerHeight() - $panel.height()
  panel_height = parent_height - header_height - panel_padding_height
  sibling_height = siblingHeight($panel, $chart)

  panel_height - sibling_height

siblingHeight = ($panel, $chart) ->
  sum = 0
  $panel.children().not($chart).each( ->
    sum += $(this).outerHeight(true)
  )
  sum

#$ ->
#  chart1 = $.get '/graphs/1.json', (data) ->
#    datas = []
#    titles = {}
#    typing = {}
#    for graph in data
#      do (graph) ->
#        titles[graph.name] = graph.name
#        typing[graph.name] = graph.type
#
#        col_vals = (val.value for val in graph.values)
#        col_vals.unshift(graph.name)
#        datas.push(col_vals)
#    window.charts.push({ "#chart-1": c3.generate(
#      bindto: "#chart-1"
#      data: {
#        columns: datas
#        #axes: titles
#        axes:  {
#          DescriptiveQueryName: 'y'
#          DescriptiveQueryName2: 'y2'
#        }
#        types: typing
#      }
#      axis: {
#        y2: {
#          show: true
#        }
#      }
#      #axis: data_axis
#    )})

  chart1 = c3.generate(ajax2Chart(1))

  chart2 = c3.generate({
    bindto: "#chart-2"
    data: {
      columns: [
        ['data1', 30, 200, 100, 400, 150, 250]
        ['data2', 130, 100, 140, 200, 150, 50]
      ]
      type: 'bar'
    }
    bar: {
      width: {
        ratio: 0.5 # this makes bar width 50% of length between ticks
      }
        # or
        # width: 100 // this makes bar width 100px
    }
  })

  chart3 = c3.generate({
    bindto: "#chart-3"
    data: {
      columns: [
        ['data1', 30, 20, 50, 40, 60, 50]
        ['data2', 200, 130, 90, 240, 130, 220]
        ['data3', 30, 20, 50, 40, 60, 50]
        ['data4', 200, 130, 90, 240, 130, 220]
      ]
      type: 'bar'
      types: {
        data3: 'line'
        data4: 'line'
      }
    }
  })

  window.charts.concat([
    { "#chart-2": chart2 }
    { "#chart-3": chart3 }
  ])

#  $('.hide-data').on('click', ->
#    chart1.hide(['data2'])
#    chart2.hide(['data2'])
#    chart3.hide(['data2'])
#  )
#
#  $('.show-data').on('click', ->
#    chart1.show(['data2'])
#    chart2.show(['data2'])
#    chart3.show(['data2'])
#  )

  drawWidgets()
  console.log(ajax2Chart(1))

