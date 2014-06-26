widget_height = 140
widget_width = 140

resizeChart = (ui)->
  $grid_obj = getGridObj(ui)
  $chart = getChart(ui)

  console.log($chart.height())
  console.log($grid_obj.height())

  new_height = 0.6 * $grid_obj.height()

  console.log()
  $chart = window.charts[chartName($chart)]

  $chart.resize({height: new_height})

getChart = (ui)->
  getGridObj(ui).find('.chart')

getGridObj = (ui)->
  $(ui.$helper.context.parentElement)

chartName = ($chart)->
  $chart.attr('id')

$ ->
  $(".grid").gridster({
    widget_margins: [10, 10],
    widget_base_dimensions: [widget_height, widget_width]
    widget_selector: '.grid-object'
    resize:
      enabled: true
      start: (event, ui) ->
        @resizeInterval =
          setInterval ->
            resizeChart(ui)
          , 333
      stop: (event, ui) ->
        clearInterval(@resizeInterval)
        setTimeout ->
          resizeChart(ui)
        , 200
  })
