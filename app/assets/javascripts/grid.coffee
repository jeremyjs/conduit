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
$(window).resize ->
  # reload the page
  location.reload()

@calculateHeight = ($item) ->
  $parent = $item.parents('.grid-item').first()
  $panel = $parent.find('.panel-body')
  $panel_header = $parent.find('.panel-heading')
  parent_height = $parent.height()
  header_height = $panel_header.outerHeight()
  panel_padding_height = $panel.outerHeight() - $panel.height()
  panel_height = parent_height - header_height - panel_padding_height
  sibling_height = siblingHeight($panel, $item)

  panel_height - sibling_height

@drawWidgets = () ->
  for name, chart of @charts
    drawChart(name, chart)
  for name, table of @tables
    drawTable(name, table)

tryDrawWidgets = ->
  console.log("test")
  if @drawWidgets
    @drawWidgets()
  else
    setTimeout ->
      tryDrawWidgets()
    , 200

$ ->
  generateCharts()
  generateTables()

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

  drawWidgets()
  $('.fullpage').fullpage
    sectionsColor: ['#666', '#888', '#aaa']
    navigation: true
