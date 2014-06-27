setWidgetDimensions = ->
  window.widget_height = 128
  window.widget_width = 128

resizeChart = (ui) ->
  $grid_item = getGridItem(ui)
  @drawChart(chartName(getChartElem(ui)))

getChartElem = (ui) ->
  getGridItem(ui).find('.chart')

getGridItem = (ui)->
  $(ui.$helper.context.parentElement)

chartName = ($chart) ->
  "#" + $chart.attr('id')

# TODO: find a better way to handle responsiveness
$(window).resize( ->
  # reload the page
  location.reload()
)
$ ->
  setWidgetDimensions()

  @drawWidgets() if @drawWidgets

  $(".grid").gridster({
    widget_margins: [10, 10],
    widget_base_dimensions: [window.widget_width, window.widget_height]
    widget_selector: '.grid-item'
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

