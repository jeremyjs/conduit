# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  chart1 = c3.generate(
    bindto: "#chart-1"
    data:
      columns: [
        ["data1", 30, 200, 100, 400, 150, 250]
        ["data2", 50, 20, 10, 40, 15, 25]
      ]
      axes: {
        data1: 'y'
        data2: 'y2'
      }
    axis: {
      y2: {
        tick: {
          # format: d3.format("%")
          format: (d)->
            return d + "%"
        }
        show: true
      }
    }
  )

  chart2 = c3.generate({
    bindto: "#chart-2"
    data: {
      columns: [
        ['data1', 30, 200, 100, 400, 150, 250]
        ['data2', 130, 100, 140, 200, 150, 50]
      ]
      type: 'bar'
    }
    bar: {
      width: {
        ratio: 0.5 # this makes bar width 50% of length between ticks
      }
        # or
        # width: 100 // this makes bar width 100px
    }
  })

  chart3 = c3.generate({
    bindto: "#chart-3"
    data: {
      columns: [
        ['data1', 30, 20, 50, 40, 60, 50]
        ['data2', 200, 130, 90, 240, 130, 220]
        ['data3', 30, 20, 50, 40, 60, 50]
        ['data4', 200, 130, 90, 240, 130, 220]
      ]
      type: 'bar'
      types: {
        data3: 'line'
        data4: 'line'
      }
    }
  })

  charts = [chart1, chart2, chart3]
  console.log(charts)

  $('.hide-data').on('click', ->
    chart1.hide(['data2'])
    chart2.hide(['data2'])
    chart3.hide(['data2'])
  )

  $('.show-data').on('click', ->
    chart1.show(['data2'])
    chart2.show(['data2'])
    chart3.show(['data2'])
  )

