// First Chart Example - Area Line Chart

data = {data1: [
	{ d: '2012-10-01', visits: 802, visits2: 1384 },
	{ d: '2012-10-02', visits: 783, visits2: 543 },
	{ d: '2012-10-03', visits: 820, visits2: 342 },
	{ d: '2012-10-04', visits: 839, visits2: 1384 },
	{ d: '2012-10-05', visits: 792, visits2: 1234 },
	{ d: '2012-10-06', visits: 859, visits2: 1384 },
	{ d: '2012-10-07', visits: 790, visits2: 2345 },
	{ d: '2012-10-08', visits: 1680, visits2: 2000 },
	{ d: '2012-10-09', visits: 1592, visits2: 1700 },
	{ d: '2012-10-10', visits: 1420, visits2: 1600 },
	{ d: '2012-10-11', visits: 882, visits2: 1384 },
	{ d: '2012-10-12', visits: 889, visits2: 1384 },
	{ d: '2012-10-13', visits: 819, visits2: 1384 },
	{ d: '2012-10-14', visits: 849, visits2: 819 },
	{ d: '2012-10-15', visits: 870, visits2: 1384 },
	{ d: '2012-10-16', visits: 1063, visits2: 1224 },
	{ d: '2012-10-17', visits: 1192, visits2: 1384 },
	{ d: '2012-10-18', visits: 1224, visits2: 1190 },
	{ d: '2012-10-19', visits: 1329, visits2: 1384 },
	{ d: '2012-10-20', visits: 1550, visits2: 1384 },
	{ d: '2012-10-21', visits: 1950, visits2: 1293 },
	{ d: '2012-10-22', visits: 2300, visits2: 1384 },
	{ d: '2012-10-23', visits: 2150, visits2: 1384 },
	{ d: '2012-10-24', visits: 1400, visits2: 1384 },
	{ d: '2012-10-25', visits: 1283, visits2: 1384 },
	{ d: '2012-10-26', visits: 1248, visits2: 1323 },
	{ d: '2012-10-27', visits: 1323, visits2: 1384 },
	{ d: '2012-10-28', visits: 1390, visits2: 1529 },
	{ d: '2012-10-29', visits: 1420, visits2: 1892 },
	{ d: '2012-10-30', visits: 1529, visits2: 1384 },
	{ d: '2012-10-31', visits: 1892, visits2: 1384 },
],
data2: [
	{ d: '2012-10-01', visits: 783 },
	{ d: '2012-10-02', visits: 820 },
	{ d: '2012-10-03', visits: 1248 },
	{ d: '2012-10-04', visits: 839 },
	{ d: '2012-10-05', visits: 792 },
	{ d: '2012-10-06', visits: 802 },
	{ d: '2012-10-07', visits: 859 },
	{ d: '2012-10-08', visits: 790 },
	{ d: '2012-10-09', visits: 1680 },
	{ d: '2012-10-10', visits: 1420 },
	{ d: '2012-10-11', visits: 882 },
	{ d: '2012-10-12', visits: 889 },
	{ d: '2012-10-13', visits: 849 },
	{ d: '2012-10-14', visits: 870 },
	{ d: '2012-10-15', visits: 1063 },
	{ d: '2012-10-16', visits: 1192 },
	{ d: '2012-10-17', visits: 1224 },
	{ d: '2012-10-18', visits: 1329 },
	{ d: '2012-10-19', visits: 1329 },
	{ d: '2012-10-20', visits: 1390 },
	{ d: '2012-10-21', visits: 819 },
	{ d: '2012-10-22', visits: 1239 },
	{ d: '2012-10-23', visits: 1190 },
	{ d: '2012-10-24', visits: 1312 },
	{ d: '2012-10-25', visits: 1283 },
	{ d: '2012-10-26', visits: 1323 },
	{ d: '2012-10-27', visits: 1420 },
	{ d: '2012-10-28', visits: 1529 },
	{ d: '2012-10-29', visits: 1293 },
	{ d: '2012-10-30', visits: 1293 },
]};

reloadMorrisArea = function() {
  $('#morris-chart-area').empty();
  var data_points = $('#lead-provider').val() == "data2" ? ['visits'] : ['visits', 'visits2'];
  new Morris.Area({
    // ID of the element in which to draw the chart.
    element: 'morris-chart-area',
    // Chart data records -- each entry in this array corresponds to a point on
    // the chart.
    data: data[$('#lead-provider').val()],
    // The name of the data record attribute that contains x-visitss.
    xkey: 'd',
    // A list of names of data record attributes that contain y-visitss.
    ykeys: data_points,
    // Labels for the ykeys -- will be displayed when you hover over the
    // chart.
    labels: ['Visits'],
    // Disables line smoothing
    smooth: false,
    fillOpacity: 0.7,
    behaveLikeLine: true
  });
}

reloadMorrisArea();

$('#lead-provider').change(function() {
  console.log($(this).val());
  reloadMorrisArea();
});
