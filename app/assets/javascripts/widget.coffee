initDatePicker = () ->
  $('.start_time').datetimepicker
    format: 'Y-m-d H:i:s'
    formatDate: 'Y-m-d H:i:s'
    mask: true
    minDate: '2004-01-01 00:00:00'
    maxDate: '+0'
    yearStart: 2004
    yearEnd: new Date().getFullYear()
    onShow: (ct, field) ->
      this.setOptions
        maxDate: $(field).parents().eq(2).find('.end_time').val()

  $('.end_time').datetimepicker
    format: 'Y-m-d H:i:s'
    formatDate: 'Y-m-d H:i:s'
    mask: true
    minDate: '2004-01-01 00:00:00'
    maxDate: '+0'
    yearStart: 2004
    yearEnd: new Date().getFullYear()
    onShow: (ct, field) ->
      this.setOptions
        minDate: $(field).parents().eq(2).find('.start_time').val()

toggleShowSettings = ->
  $(this).parents('.panel-default').find('.panel-body').toggle()
  $(this).parents('.panel-default').find('.panel-settings').toggle()
  $(this).toggleClass('hidden')
  $(this).siblings().not('.panel-title, .panel-subtitle').toggleClass('hidden')

updateWidgetPage = (data, spinner, warning) ->
  $.ajax
    type: 'post'
    data: data
    url: '/widget/update_page/'
    dataType: 'json'
    complete: ->
      stopSpinner = () ->
        spinner.spin(false)
      spinner.fadeOut(750, stopSpinner)
      warning.fadeIn()

$ ->
  tabby.init()

  initDatePicker()

  $('.rotate').textrotator
    animation: 'flipUp'
    separator: '|'
    speed: 3000

  $('.new').click ->
    $.ajax
      type: 'post'
      data:
        widget:
          page: window.currentPage
          type: $(this).attr('widget_type')
      url: '/widgets'
      dataType: 'json'
      complete: ->
        location.reload()

  $('.panel-heading > .btn').click toggleShowSettings

  $('.query-type-select').change ->
    query_selector = $(this)
    $.ajax
      type: 'get'
      url: '/widget_variables/' + query_selector.val()
      success: (data) ->
        query_selector.parent().find('.widget-variables-field')[0].innerHTML = data
        initDatePicker()

  $('.save-widget-btn').click (event) ->
    event.preventDefault()

    outer = $(this).parents('.panel-settings')
    outer.addClass('ajax-disabled')

    body = $(this).parents('.panel-default').find('.panel-body')
    body.addClass('ajax-disabled')

    spinner = $(this).parents('.panel-default').find('.panel-spinner')
    warning = $(this).parents('.panel-default').find('.panel-freshness')
    spinner.fadeIn(750)
    spinner.spin({lines:9, length:0, width:10, radius:31, corners:1.0, trail:100})

    current_widget = outer.find('.current-widget').val()

    getKeys = (selector) ->
      outer.find(selector).map ->
        $(this).attr('key')

    getValues = (selector) ->
      outer.find(selector).map ->
        $(this).val()

    data =
      widget:
        title: ''
        variables: {}
        display_variables: {}

    widget_fields = 'input.query-name'
    widget_keys = getKeys(widget_fields)
    widget_values = getValues(widget_fields)

    widget_keys.push('query_id')
    if outer.find('.query-type-select').val() == null
      widget_values.push outer.find('.current-query').val()
    else
      widget_values.push outer.find('.query-type-select').val()

    variables_fields = 'input.widget-variables'
    variables_keys = getKeys(variables_fields)
    variables_values = getValues(variables_fields)

    for w_attr, i in widget_keys
      data.widget[w_attr] = widget_values[i]

    for v_attr, i in variables_keys
      data.widget.variables[v_attr] = variables_values[i]

    kpis = ->
      $kpis_checked = outer.find('.graph-columns-field input').map ->
        $(this).val() if this.checked
      $.makeArray($kpis_checked).filter (s) -> s != ''

    data.widget.display_variables['kpis'] = kpis()

    $.ajax
      type: 'patch'
      data: data
      url: '/widgets/' + current_widget
      dataType: 'json'
      complete: ->
        page_selector = outer.find('.widget-page-selector')
        data =
          id: page_selector.attr('for_widget')
          page: page_selector.val() || page_selector.attr('current_page')
        updateWidgetPage(data, spinner, warning)
