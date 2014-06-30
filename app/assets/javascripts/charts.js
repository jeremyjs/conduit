window.charts = [];

this.getChart = function(id) {
  var col_vals, data, datas, graph, titles, typing, val, i, len, dataArray;
  var globalData;
  $.ajax(
  {
    url: "/graphs/" + id + ".json",
    async: false,
    success: function(data)
    {
      globalData = data;
    }
  });
  datas = [];
  titles = {};
  typing = {};
    dataArray = globalData;
  for (i = 0, len = dataArray.length; i < len; i++) {
    graph = dataArray[i];
    titles[graph.name] = graph.name;
    typing[graph.name] = graph.type;
    col_vals = (function() {
      var j, len1, graphArray, results;
      graphArray = graph.values;
      results = [];
      for (j = 0, len1 = graphArray.length; j < len1; j++) {
        val = graphArray[j];
        results.push(val.value);
      }
      return results;
    })();
    col_vals.unshift(graph.name);
    datas.push(col_vals);
  }
  return {
    bindto: "#chart-" + id,
    data: {
      columns: datas,
      axes: {
        DescriptiveQueryName: 'y',
        DescriptiveQueryName2: 'y2'
      },
      types: typing
    },
    axis: {
      y2: {
        show: true
      }
    }
  };
};

this.drawWidgets = function() {
  var chart, name, _ref, _results;
  _ref = window.charts;
  _results = [];
  for (name in _ref) {
    chart = _ref[name];
    _results.push(this.drawChart(name, chart));
  }
  return _results;
};

this.drawChart = function(name, chart) {
  var $chart_elem, new_height;
  if (!chart) {
    chart = window.charts[name];
  }
  $chart_elem = $(name);
  new_height = calculateHeight($chart_elem);
  return chart.resize({
    height: new_height
  });
};

var calculateHeight = function($chart) {
  var $panel, $panel_header, $parent, header_height, panel_height, panel_padding_height, parent_height, sibling_height;
  $parent = $chart.parents('.grid-item').first();
  $panel = $parent.find('.panel-body');
  $panel_header = $parent.find('.panel-heading');
  parent_height = $parent.height();
  header_height = $panel_header.outerHeight();
  panel_padding_height = $panel.outerHeight() - $panel.height();
  panel_height = parent_height - header_height - panel_padding_height;
  sibling_height = siblingHeight($panel, $chart);
  return panel_height - sibling_height;
};

var siblingHeight = function($panel, $chart) {
  var sum = 0;
  $panel.children().not($chart).each(function() {
    sum += $(this).outerHeight(true);
  });
  return sum;
};

$(document).ready(function() {
  var chart1 = c3.generate(getChart(1));
  var chart2 = c3.generate(getChart(2));
  var chart3 = c3.generate(getChart(3));
  window.charts = {
      "#chart-1": chart1,
      "#chart-2": chart2,
      "#chart-3": chart3
    }
  drawWidgets();
});
