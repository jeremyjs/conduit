widgetDimensions = ->
  # [height, width]
  [128, 128]

resizeChart = (ui) ->
  $grid_item = getGridItem(ui)
  @drawChart(chartName(getChartElem(ui)))

getGridItem = (ui)->
  $(ui.$helper.context.parentElement)

chartName = ($chart) ->
  "#" + $chart.attr('id')

getChartElem = (ui) ->
  getGridItem(ui).find('.chart')

# TODO: find a better way to handle responsiveness
$(window).resize( ->
  # reload the page
  location.reload()
)

tryDrawWidgets = ->
  console.log("test")
  if @drawWidgets
    @drawWidgets()
  else
    setTimeout ->
      tryDrawWidgets()
    , 200

$ ->
  $('.tables').dataTable
    sDom: 'C<"clear">lfrtip'

  $(".grid").gridster({
    widget_margins: [10, 10]
    widget_base_dimensions: [128, 128]
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

  margin_val = parseInt($('.grid').css('marginRight'))

  $('.grid').css('marginRight', 0)
  $('.grid').css('marginLeft', 0)

  $('.container-fluid').children().css('marginRight', margin_val)
  $('.container-fluid').children().css('marginLeft', margin_val)
  $('.container-fluid').children().not('.gridster').css('paddingRight', 10)
  $('.container-fluid').children().not('.gridster').css('paddingLeft', 10)
