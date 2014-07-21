@getProviders = ->
  providers = null
  $.ajax
    url: "/providers.json"
    async: false
    success: (response) ->
      providers = response
  providers

$ ->
  split = (val) ->
    val.split /,\s*/
  extractLast = (term) ->
    split(term).pop()
  availableTags = ["eloansuk", "elephant", "echo", "apple"]

  # don't navigate away from the field on tab when selecting an item
  $("#providers").bind("keydown", (event) ->
    event.preventDefault()  if event.keyCode is $.ui.keyCode.TAB and $(this).autocomplete("instance").menu.active
    return
  ).autocomplete
    minLength: 0
    source: (request, response) ->

      # delegate back to autocomplete, but extract the last term
      response $.ui.autocomplete.filter(availableTags, extractLast(request.term))
      return

    focus: ->

      # prevent value inserted on focus
      false

    select: (event, ui) ->
      terms = split(@value)

      # remove the current input
      terms.pop()

      # add the selected item
      terms.push ui.item.value

      # add placeholder to get the comma-and-space at the end
      terms.push ""
      @value = terms.join(", ")
      false

  return

