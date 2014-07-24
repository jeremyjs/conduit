@tables = {}

columns = []
hidden_columns = []

@getTableData = (id) ->
  globalData = null
  $.ajax
    url: "/tables/" + id + ".json"
    async: false
    success: (data) ->
      globalData = data

  for key of globalData.data[0]
    columns.push(key)

  for column in globalData.hide
    hidden_columns.push(column)

  determineHiddenColumns()
  globalData

determineHiddenColumns = () ->
  table_options = []
  for hidden_column in hidden_columns
    table_options.push({visible: false, targets: columns.indexOf(hidden_column)})
  table_options

generateHeaders = (table) ->
  table_id = '#table-' + table.id
  if table.data[0]
    headers = table.data[0]
    $table_header = $(table_id).children("thead")
    $header_row = $table_header.children("tr").empty()
    for key of headers
      $header_row.append("<th>" + key + "</th>")

generateBody = (table) ->
  table_id = '#table-' + table.id
  $table_body = $(table_id).children("tbody").empty()
  table_data = table.data
  if table_data.length > 0
    for row in table_data
      $table_body.append("<tr>")
      $row = $table_body.children("tr").last()

      for key, value of row
        $row.append("<td>" + value + "</td>")

generateFooter = (table) ->
  table_id = '#table-' + table.id
  footers = table.data[0]

  $table_footer = $(table_id).children("tfoot")
  $footer_row = $table_footer.children("tr").empty()
  for key of footers
    $footer_row.append("<th>" + key + "</th>")

@renderTable = (table) ->
  # table -> { id: <id>, data: [ {}, {}... ] }
  generateHeaders(table)
  generateBody(table)
  generateFooter(table)

@drawTable = (name, table) ->
  table = tables[name] unless table
  table_id = name.replace /#/, ""
  $table_elem = $('#' + table_id + '_wrapper')
  $table_elem = $('#' + table_id) if $table_elem.length == 0
  $grid_item = $table_elem.parents('.grid-item')
  $parent = $table_elem.parent()
  $parent.html('<table class="display tables" id="'+table_id+'" cellspacing="0" width="100%"><thead><tr><th></th></tr></thead><tbody><tr><td></td></tr></tbody></table>')
  $table_elem = $parent.children('table')
  table_height = $grid_item.height() - $grid_item.children('.panel-heading').outerHeight() - 145
  generateTable($table_elem, table_height)

@defaultOptions =
  sDom: 'TC<"clear">lfrtip'
  sScrollY: '160px'
  sScrollX: true
  stateSave: true
  tableTools:
    aButtons: [
      sExtends: "collection"
      sButtonText: "Export"
      aButtons: [
        sExtends: "copy"
        sButtonText: "Copy"
        mColumns: "visible"
      ,
        sExtends: "csv"
        sButtonText: "CSV"
        mColumns: "visible"
      ,
        sExtends: "pdf"
        sPdfOrientation: "landscape"
        sButtonText: "PDF"
        mColumns: "visible"
      ]
    ]

@generateTable = (table, height) ->
  $table = $(table)
  name = $(table).attr('id')
  id = name.substring(6)
  data = getTableData(id)
  renderTable(data)

  defaultOptions.columnDefs = determineHiddenColumns()
  defaultOptions.sScrollY = height

  tables[name] = $table.dataTable(defaultOptions)

@generateTables = ->
  $('.tables').each ->
    generateTable(this, 200)
