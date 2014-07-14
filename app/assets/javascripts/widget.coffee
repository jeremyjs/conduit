$ ->
  $('.widget-page-selector').change ->
    data =
      id: $(this).attr('for_widget')
      page: $(this).val()

    $.ajax
      type: "post"
      data: data
      url: "/widget/update_page/"
      dataType: "json"
      complete: ->
        location.reload()
  
  $('.new').click ->
    $.ajax
      type: "post"
      data:
        widget:
          page: window.currentPage
          type: $(this).attr('widget_type')
      url: "/widgets"
      dataType: "json"
      complete: ->
        location.reload()

  $('.widget-settings-toggle').click ->
    $(this).parents().eq(2).find('.panel-body').toggle()
    $(this).parents().eq(2).find('.panel-settings').toggle()
