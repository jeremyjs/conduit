@getProviders = (brand_id) ->
  providers = []
  $.ajax
    url: "/providers/#{brand_id}.json"
    async: false
    success: (response) ->
      for provider in response
        providers.push("'" + provider.name + "'")
  providers

$ ->
  split = (val) ->
    val.split /,\s*/
  extractLast = (term) ->
    split(term).pop()
  brand_providers = getProviders($('.brand_id').val())

  $('.brand_id').focusout -> 
    brand = $(this).val()
    brand_providers = getProviders(brand)


  # don't navigate away from the field on tab when selecting an item
  $(".providers").bind("keydown", (event) ->
    event.preventDefault()  if event.keyCode is $.ui.keyCode.TAB and $(this).autocomplete("instance").menu.active
    return
  ).autocomplete
    minLength: 0
    source: (request, response) ->

      # delegate back to autocomplete, but extract the last term
      response $.ui.autocomplete.filter(brand_providers, extractLast(request.term))
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
