widget_height = 140
widget_width = 140

resizeChart = (ui)->
  $chart = getChart(ui)
  console.log($chart)
  # new_height = 0.8 * $chart.height
  $chart.resize()

getChart = (ui)->
  $(ui.$helper.context.parentElement).find('.chart')

$ ->
  $(".gridster ul").gridster({
    widget_margins: [10, 10],
    widget_base_dimensions: [widget_height, widget_width]
    widget_selector: '.grid-object'
    resize:
      enabled: true
      start: (event, ui) ->
        console.log(ui)
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
