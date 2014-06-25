# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
chart = c3.generate(
  bindto: "#chart-1"
  data:
    columns: [
      ["data1", 30, 200, 100, 400, 150, 250]
      ["data2", 50, 20, 10, 40, 15, 25]
    ]
)
