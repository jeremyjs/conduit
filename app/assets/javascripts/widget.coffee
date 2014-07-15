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

  $('.edit-widget-btn').click ->
    current_widget = $(this).parent().find('.current-widget').val()
    data =
      widget: {}
      variables: {}

    widget_attributes = 'input:not(.widget-variables):not(.current-query):not(.current-widget)'
    widget = $(this).parent().find(widget_attributes).map ->
      $(this).attr('key')
    widget_values = $(this).parent().find(widget_attributes).map ->
      $(this).val()

    widget.push('query')
    if $(this).parent().find('.query-type').val() == null
      widget_values.push $(this).parent().find('.current-query').val()
    else
      widget_values.push $(this).parent().find('.query-type').val()


    widget_variables = 'input.widget-variables'
    variables = $(this).parent().find(widget_variables).map ->
      $(this).attr('key')
    variables_values = $(this).parent().find(widget_variables).map ->
      $(this).val()

    for w_attr, i in widget
      data.widget[w_attr] = widget_values[i]

    for v_attr, i in variables
      data.variables[v_attr] = variables_values[i]

    $.ajax
      type: "patch"
      data: data
      url: "/widgets/"+current_widget
      dataType: "json"
      complete: ->
        location.reload()
