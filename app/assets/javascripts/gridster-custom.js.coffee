$ ->
  $(".gridster ul").gridster({
    widget_margins: [10, 10],
    widget_base_dimensions: [140, 140]
    widget_selector: '.grid-object'
    resize:
      enabled: true
      start: (event, ui) -> 
        chart_num = $(ui.$helper.context.parentElement).find('.chart').attr('id').slice(-1)
        @resizeInterval = 
          setInterval ->
            $('#chart-'+chart_num).resize()
          , 333
      stop: (event, ui) -> 
        chart_num = $(ui.$helper.context.parentElement).find('.chart').attr('id').slice(-1)
        clearInterval(@resizeInterval)
        setTimeout ->
          $('#chart-'+chart_num).resize()
        , 200
  })
