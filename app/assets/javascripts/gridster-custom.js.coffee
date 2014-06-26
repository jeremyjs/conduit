$ ->
  $(".gridster ul").gridster({
    widget_margins: [10, 10],
    widget_base_dimensions: [140, 140]
    widget_selector: '.grid-object'
    resize:
      enabled: true
      start: -> 
        @resizeInterval = 
          setInterval ->
            $('#chart-1').resize()
            console.log('asdfadsf')
          , 333
      stop: -> 
        clearInterval(@resizeInterval)
        setTimeout ->
          $('#chart-1').resize()
        , 200
  })
