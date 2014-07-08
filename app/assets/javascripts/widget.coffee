$ ->
  $('.widget-page-selector').change ->
    data =
      id: $(this).attr('for_widget')
      page: $(this).val()

    #current_widget = $(this).parents().eq(2)
    #current_widget_sizex = current_widget.attr('data-sizex')
    #current_widget_sizey = current_widget.attr('data-sizey')

    #from_grid = $(this).parents().eq(3).gridster().data('gridster')
    #from_grid.remove_widget(current_widget)

    #console.log(current_widget)

    #to_grid = $('#page-'+data.page).gridster().data('gridster')
    #to_grid.add_widget(current_widget.html(), current_widget_sizex, current_widget_sizey)

    $.ajax
      type: "post"
      data: data
      url: "/widget/update_page/"
      dataType: "json"
      complete: ->
        location.reload()
        console.log('reloading...')
      
    
