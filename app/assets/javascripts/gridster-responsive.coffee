fnCreateGridster = (page, colors, states, titles) ->

  # force 1 column on mobile screen sizes

  # get the default size for the ratio

  # start gridster

  # start color selctor to change title colors

  # load title colors

  # load states (after colors)

  # register the minimize button

  # register the maximize button

  # register the close button

  # helpers
  _state_update = (panel, _state) ->
    _states =
      panel: panel
      state: _state

    if localdata_states
      $.each localdata_states, (i, value) ->
        localdata_states.splice i, 1  if value.panel is panel  if value
        return

    else
      localdata_states = []
    localdata_states.push _states
    localStorage.setItem states, JSON.stringify(localdata_states)
    return
  _state_maxamize = (panel) ->
    $("#" + panel + "").attr "data-state", "max"
    _oldsize = parseInt($("#" + panel).attr("data-sizey-old"))
    $("#" + panel + "").attr "data-sizey", _oldsize
    $(".gridster > ul").data("gridster").resize_widget $("#" + panel), $("#" + panel).attr("data-sizex"), _oldsize
    $("#" + panel + " .panel").css "padding-bottom", "60px"
    $("#" + panel + " .panel-body").slideDown()
    $("#" + panel + " .panel-hide").removeClass("glyphicon-plus").addClass "glyphicon-minus"
    $("#" + panel + " .gs-resize-handle").show()
    $("#" + panel + " .panel-color, #" + panel + " .panel-max, #" + panel + " .panel-close").show()
    return
  _state_minimize = (panel) ->
    $("#" + panel + "").attr "data-state", "min"
    $("#" + panel).attr "data-sizey-old", $("#" + panel).attr("data-sizey")
    $(".gridster > ul").data("gridster").resize_widget $("#" + panel), $("#" + panel).attr("data-sizex"), 1
    $("#" + panel).attr "data-sizey", "1"
    $("#" + panel + " .gs-resize-handle").hide()
    $("#" + panel + " .panel-body").slideUp()
    $("#" + panel + " .panel-hide").removeClass("glyphicon-minus").addClass "glyphicon-plus"
    $("#" + panel + " .panel").css "padding-bottom", "0px"
    $("#" + panel + " .panel-color, #" + panel + " .panel-max, #" + panel + " .panel-close").hide()
    return
  _resize_gridster = ->
    gridster.resize_widget_dimensions
      widget_base_dimensions: [
        ((base_size * ($(window).width() / base_size)) / cols) - offset
        50
      ]
      widget_margins: [
        5
        5
      ]

    return
  _save_titles = (th, newValue) ->
    t = $(th).parents("li").attr("id")
    _title =
      panel: t
      title: newValue

    if localdata_titles
      $.each localdata_titles, (i, value) ->
        localdata_titles.splice i, 1  if value.panel is t  if value
        return

    else
      localdata_titles = []
    localdata_titles.push _title
    localStorage.setItem titles, JSON.stringify(localdata_titles)
    return
  _save_colors = (t, color) ->
    $("#" + t + " .panel-heading").css "background-color", color
    _color =
      panel: t
      color: color

    if localdata_colors
      $.each localdata_colors, (i, value) ->
        localdata_colors.splice i, 1  if value.panel is t  if value
        return

    else
      localdata_colors = []
    localdata_colors.push _color
    localStorage.setItem colors, JSON.stringify(localdata_colors)
    return
  if $(window).width() <= 480 or $(window).width() is 640
    cols = 1
    offset = 40
  else
    cols = 2
    offset = 20
  base_size = ($(window).width() / cols) - offset
  gridster = $(".gridster > ul").gridster(
    extra_cols: 1
    autogrow_cols: true
    min_cols: 1
    max_cols: cols
    widget_margins: [
      5
      5
    ]
    widget_base_dimensions: [
      base_size
      50
    ]
    resize:
      enabled: true
      stop: (event, ui, widget) ->
        positions = JSON.stringify(@serialize())
        localStorage.setItem page, positions
        return

    serialize_params: ($w, wgd) ->
      id: $($w).attr("id")
      col: wgd.col
      row: wgd.row
      size_x: wgd.size_x
      size_y: wgd.size_y

    draggable:
      handle: ".panel-heading, .panel-handel"
      stop: (event, ui) ->
        _positions = @serialize()
        $.each _positions, (i, value) ->
          _state = $("#" + value.id).attr("data-state")
          if _state is "min"
            value.size_y = $("#" + value.id).attr("data-sizey-old")
            _positions[i] = value
          return

        positions = JSON.stringify(_positions)
        localStorage.setItem page, positions
        return
  ).data("gridster")
  $(".colorselector").colorselector callback: (t, value, color, title) ->
    _save_colors t, color
    return

  if localdata_colors
    $.each localdata_colors, (i, value) ->
      $("#" + value.panel + " .panel-heading, #" + value.panel + " .btn-colorselector").css "background-color", value.color  if value
      return

  if localdata_states
    $.each localdata_states, (i, value) ->
      if value
        console.log value
        if value.state is "closed"
          $(".gridster > ul").data("gridster").remove_widget $("#" + value.panel)
        else _state_minimize value.panel  if value.state is false
      return

  $(document).on "click", ".panel-hide", (e) ->
    e.preventDefault()
    panel = $(this).attr("data-id")
    if $(this).hasClass("glyphicon-minus")
      _state_minimize panel
      _state = false
    else
      _state_maxamize panel
      _state = true
    _state_update panel, _state
    return

  $(document).on "click", ".panel-max", (e) ->
    e.preventDefault()
    panel = $(this).attr("data-id")
    if $(this).hasClass("glyphicon-resize-small")
      $(".main-nav").show()
      $("#" + panel).find(".hide-full").show()
      $("#" + panel + " .gs-resize-handle").hide()
      $("#" + panel).css
        position: "absolute"
        top: $("#" + panel).attr("data-top")
        left: $("#" + panel).attr("data-left")
        width: $("#" + panel).attr("data-width")
        height: $("#" + panel).attr("data-height")
        "z-index": "0"

      $(this).removeClass("glyphicon-resize-small").addClass "glyphicon-resize-full"
    else
      $(".main-nav").hide()
      _position = $("#" + panel).position()
      $("#" + panel).attr
        "data-width": $("#" + panel).width()
        "data-height": $("#" + panel).height()
        "data-left": _position.left
        "data-top": _position.top

      $("#" + panel).css
        position: "fixed"
        top: "0"
        left: "0"
        width: "100%"
        height: "100%"
        "z-index": "9999"

      $(this).removeClass("glyphicon-resize-full").addClass "glyphicon-resize-small"
      $("#" + panel + " .gs-resize-handle").show()
      $("#" + panel).find(".hide-full").hide()
    return

  $(document).on "click", ".panel-close", (e) ->
    e.preventDefault()
    panel = $(this).attr("data-id")
    bootbox.confirm "Are you sure?", (result) ->
      if result
        $(".gridster > ul").data("gridster").remove_widget $("#" + panel)
        _state_update panel, "closed"
      return

    return


  # make titles editable
  $(".panel-title-text").editable
    mode: "inline"
    showbuttons: "false"
    placeholder: "Title"
    success: (response, newValue) ->
      _save_titles this, newValue
      return


  # we're ready for the show
  $(window).on "resize load", _resize_gridster

  # give it a bit to fully load then fade in
  setTimeout (->
    $(".gridster").fadeIn "fast"
    return
  ), 400
  return
