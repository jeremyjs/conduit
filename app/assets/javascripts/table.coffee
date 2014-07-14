@tables = {}

columns = []
hidden_columns = []

@getTableData = (id) ->
  globalData = null
  $.ajax(
    url: "/query_tables/" + id + ".json"
    async: false
    success: (data) ->
      globalData = data
  )

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
  headers = table.data[0]

  $table_header = $(table_id).children("thead")
  $header_row = $table_header.children("tr").empty()
  for key of headers
    $header_row.append("<th>" + key + "</th>")

generateBody = (table) ->
  table_id = '#table-' + table.id
  $table_body = $(table_id).children("tbody").empty()
  table_data = table.data

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
  $table_elem = $(name + '_wrapper')
  new_height = calculateHeight($table_elem)
  $table_elem.css('height', calculateHeight($table_elem))
  defaultOptions.sScrollY = calculateHeight($table_elem)
  table.fnAdjustColumnSizing()

@generateTables = ->
  @defaultOptions =
    sDom: 'C<"clear">lfrtip'
    sScrollY: '175px'
    sScrollX: true

  $('.tables').each ->
    name = '#' + this.id
    id = this.id.substring(6)
    renderTable(getTableData(id))

    defaultOptions.columnDefs = determineHiddenColumns()

    tables[name] = $(this).dataTable(defaultOptions)
