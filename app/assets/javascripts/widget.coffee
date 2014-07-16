$ ->
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
    outer = $(this).parent()

    getKeys = (selector) ->
      outer.find(selector).map ->
        $(this).attr('key')
  
    getValues = (selector) ->
      outer.find(selector).map ->
        $(this).val()

    current_widget = outer.find('.current-widget').val()

    data =
      widget: {}
      variables: {}

    widget_fields = 'input:not(.widget-variables):not(.current-query):not(.current-widget)'
    widget_keys = getKeys(widget_fields)
    widget_values = getValues(widget_fields)

    widget_keys.push('query')
    if outer.find('.query-type').val() == null
      widget_values.push outer.find('.current-query').val()
    else
      widget_values.push outer.find('.query-type').val()

    variables_fields = 'input.widget-variables'
    variables_keys = getKeys(variables_fields)
    variables_values = getValues(variables_fields)

    for w_attr, i in widget_keys
      data.widget[w_attr] = widget_values[i]

    for v_attr, i in variables_keys
      data.variables[v_attr] = variables_values[i]

  

    $.ajax
      type: "patch"
      data: data
      url: "/widgets/"+current_widget
      dataType: "json"
      complete: ->
        page_selector = outer.find('.widget-page-selector')
        data =
          id: page_selector.attr('for_widget')
          page: page_selector.val() || page_selector.attr('current_page')

        $.ajax
          type: "post"
          data: data
          url: "/widget/update_page/"
          dataType: "json"
          complete: ->
            location.reload()
