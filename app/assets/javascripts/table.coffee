@tables = {}

@getTable = (id) ->
  globalData = null
  $.ajax(
    url: "/query_tables/" + id + ".json"
    async: false
    success: (data) ->
      globalData = data
  )
  globalData

@generateHeaders = (table) ->
  table_id = '#table-' + table.id
  headers = table.data[0]

  $table_header = $(table_id).children("thead")
  $header_row = $table_header.children("tr").empty()
  for key of headers
    $header_row.append("<th>" + key + "</th>")

@generateBody = (table) ->
  table_id = '#table-' + table.id
  $table_body = $(table_id).children("tbody").empty()
  table_data = table.data

  for row in table_data
    $table_body.append("<tr>")
    $row = $table_body.children("tr").last()

    for key, value of row
      $row.append("<td>" + value + "</td>")

@generateFooter = (table) ->
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
  table = @tables[name] unless table
  $table_elem = $(name + '_wrapper')
  new_height = calculateHeight($table_elem)
  $table_elem.css('height', calculateHeight($table_elem))
  defaultOptions.sScrollY = calculateHeight($table_elem)
  table.fnAdjustColumnSizing()

@generateTables = ->
  @defaultOptions =
    sDom: 'C<"clear">lfrtip'

  $('.tables').each ->
    name = '#' + this.id
    id = this.id.substring(6)
    table = getTable(id)
    renderTable(table)
    tables[name] = $(this).dataTable(defaultOptions)

