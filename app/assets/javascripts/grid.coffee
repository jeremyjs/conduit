gridUnits =
  height: 64
  width: 64

widgetPadding =
  height: 10
  width: 10

widgetOuterDimensions =
  height: gridUnits["height"] + widgetPadding["height"] * 2
  width: gridUnits["width"] + widgetPadding["width"] * 2

saveWidget = ($grid_item) ->
  name = $grid_item[0].id
  id = getId(name)
  height = $grid_item.attr('data-sizey')
  width = $grid_item.attr('data-sizex')
  row = $grid_item.attr('data-row')
  column = $grid_item.attr('data-col')
  $.ajax 
    url: "/widgets/" + id
    method: 'patch'
    commit: 'Save'
    data:
      widget:
        height: height
        width: width
        row: row
        column: column

resizeWidget = (ui, event) ->
  console.log event
  $grid_item = getGridItem(ui)
  $chart = $grid_item.find('.chart')
  $table = $grid_item.find('.dataTables_wrapper')
  console.log $chart
  console.log $table
  drawChart(getName($chart)) unless $chart.length == 0
  drawTable(getName($table)) unless $table.length == 0 || event.type == "mousemove"

getGridItem = (ui) ->
  $(ui.$helper.context.parentElement)

getName = ($item) ->
  "#" + $item.attr('id').replace /_wrapper/, ""

@calculateHeight = ($item) ->
  $parent = $item.parents('.grid-item').first()
  $panel = $item.parents('.panel-body')
  $panel_header = $parent.find('.panel-heading')
  parent_height = $parent.height()
  header_height = $panel_header.outerHeight()

  panel_padding = $panel.outerHeight() - $panel.height()
  panel_height = parent_height - header_height - panel_padding

  panel_height

@drawChart = (name, chart) ->
  chart = charts[name] unless chart
  $chart_elem = $(name)
  new_height = calculateHeight($chart_elem)
  chart.resize({ height: new_height })

@drawWidgets = () ->
  for name, chart of @charts
    drawChart(name, chart)
  for name, table of @tables
    drawTable(name, table)

tryDrawWidgets = ->
  if @drawWidgets
    @drawWidgets()
  else
    setTimeout ->
      tryDrawWidgets()
    , 200

justifyContainerElements = ->
  margin_val = parseInt($('.grid').css('marginRight'))
  container_class = '.fullpage .section'

  $(container_class).children().css('marginRight', margin_val)
  $(container_class).children().css('marginLeft', margin_val)
  $(container_class).children().not('.gridster').css('paddingRight', 10)
  $(container_class).children().not('.gridster').css('paddingLeft', 10)

setGridPadding = ->
  grid_total_padding = parseInt( $('.grid').css('padding-left'), 10) +
                       parseInt( $('.container-fluid').css('padding-left'), 10) +
                       parseInt( $('.container-fluid').css('padding-right'), 10) +
                       $('#fp-nav').outerWidth(true)

  $('.grid').css('padding-left', grid_total_padding)

getMaxRows = ->
  max_height = $(window).height()-$('.navbar-conduit').height()
  Math.floor(max_height  / widgetOuterDimensions["height"])

getMaxColumns = ->
  max_width = $(window).width() -
    parseInt( $('.container-fluid').css('padding-left'), 10) -
    parseInt( $('.container-fluid').css('padding-right'), 10) -
    $('#fp-nav').outerWidth(true)
  Math.floor(max_width / widgetOuterDimensions["width"])

getGridDimensions = ->
  [getMaxRows(), getMaxColumns()]

# reload the page when the window is resized
$(window).resize ->
  location.reload()

$ ->
  generateTables()

  [rows, columns] = getGridDimensions()

  $(".grid").gridster
    widget_margins: [
      widgetPadding['width']
      widgetPadding['height']
    ]
    widget_base_dimensions: [
      gridUnits['width']
      gridUnits['height']
    ]
    widget_selector: '.grid-item'
    min_cols: columns
    max_cols: columns
    resize:
      enabled: true
      start: (event, ui) ->
        @resizeInterval =
          setInterval ->
            resizeWidget(ui, event)
          , 333
      stop: (event, ui) ->
        clearInterval(@resizeInterval)
        setTimeout ->
          resizeWidget(ui, event)
        , 200
        saveWidget(getGridItem(ui))
    draggable:
      handle: '.panel-heading'
      stop: (event, ui) ->
        $grid = $(event.target).closest('.grid')
        $grid.children('.grid-item').each ->
          saveWidget $(this)

  justifyContainerElements()

  $('.chart').each ->
    name = '#' + $(this).attr('id')
    id = name.substring(7)
    chart = getChartData(id)
    charts[name] = renderChart chart

  drawWidgets()

  setGridPadding()

