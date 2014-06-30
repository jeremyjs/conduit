this.getTable = function(id) {
  var col_vals, data, datas, graph, titles, typing, val, i, len, dataArray;
  var globalData;
  $.ajax(
  {
    url: "/query_tables/" + id + ".json",
    async: false,
    success: function(data)
    {
      globalData = data;
    }
  });
  return globalData
};

function generateHeaders(table) {
  var table_id = '#table-' + table.id;
  headers = table.data[0];

  $table_header = $(table_id).children("thead");
  $header_row = $table_header.children("tr").empty();
  for (var key in headers) {
    $header_row.append("<th>" + key + "</th>");
  }
}

function generateBody(table) {
  var table_id = '#table-' + table.id;
  var $table_body = $(table_id).children("tbody").empty();
  var table_data = table.data;
  for (var index in table_data) {
    var row = table_data[index];

    $table_body.append("<tr>");
    var $row = $table_body.children("tr").last();

    for (var key in row) {
      var value = row[key];
      $row.append("<td>" + value + "</td>");
    }
  }
};

function generateFooter(table) {
  var table_id = '#table-' + table.id;
  footers = table.data[0];

  $table_footer = $(table_id).children("tfoot");
  $footer_row = $table_footer.children("tr").empty();
  for (var key in footers) {
    $footer_row.append("<th>" + key + "</th>");
  }
}

this.renderTable = function(table) {
  // table -> [ {}, {}... ]

  generateHeaders(table);

  generateBody(table);

  generateFooter(table);
};

$(document).ready(function() {
  var table = getTable(2);
  renderTable(table);
});
