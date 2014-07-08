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
      
    
