$ ->
  $('#user-providers-select').selectize()
  $('#map_roles').click ->
    $.ajax
      type: 'post'
      url: "/ldap_role_mappings"
      data:
        ldap_group: $("#ldap-group-select").val()
        role: $("#role-select").val()
      success: (response) ->
        li_open_tag = "<li>"
        li_content = $('#list_of_mappings>li.hidden').html()
        li_content = li_content.replace(/ajax_mapping_id/g, response.id)
        li_content = li_content.replace(/ajax_ldap_name/g, response.ldap_group.match(/CN=(.*?),/)[1])
        li_content = li_content.replace(/ajax_mapping_role/g, response.role)
        li_close_tag = "</li>"

        new_li_element = li_open_tag + li_content + li_close_tag
        $('#list_of_mappings').append($(new_li_element).hide().fadeIn())
        bind_delete_mapping_button()

  $('#map_users').click ->
    mappings = {}
    $('#list_of_users>li:not(.hidden)>input').each ->
      if mappings[$(this).attr('user')] == undefined
        mappings[$(this).attr('user')] = ['nil']
      if $(this).is(':checked')
        mappings[$(this).attr('user')].push $(this).attr('value')

    $.ajax
      type: 'patch'
      url: '/user_role_mappings'
      data:
        mappings: mappings

  bind_delete_user_button = () ->
    $('.delete_user').click ->
      self = $(this)
      email = $(this).parent().find('.user-email').text()
      if confirm('Are you sure you want to delete '+email+'?')
        $.ajax
          type: 'delete'
          url: '/delete_user'
          data:
            email: email
          success: () ->
            self.parent().fadeOut()

  bind_delete_user_button()

  bind_delete_mapping_button =  () ->
    $('.delete_mapping').click ->
      self = $(this)
      mapping_id = $(this).parent().find('.ldap-mapping-group').attr('mapping_id')
      if confirm('Are you sure you want to delete this LDAP mapping?')
        $.ajax
          type: 'delete'
          url: '/delete_ldap_mapping'
          data:
            mapping_id: mapping_id
          success: () ->
            self.parent().fadeOut()

  bind_delete_mapping_button()

  $('#add_user_form_button').click (event) ->
    event.preventDefault()
    serialized_data = $('#add_user_form').serializeArray()
    form_data = {}
    for one_serialized_data in serialized_data
      if one_serialized_data.name of form_data
        if typeof form_data[one_serialized_data.name] == "string"
          form_data[one_serialized_data.name] = [form_data[one_serialized_data.name]]
        form_data[one_serialized_data.name].push(one_serialized_data.value)
      else
        form_data[one_serialized_data.name] = one_serialized_data.value

    $.ajax
      type: 'post'
      url: '/add_user'
      data: form_data
      success: (response) ->
        li_open_tag = "<li>"
        li_close_tag = "</li>"
        li_content = $('#list_of_users>li.hidden').html()
        li_content = li_content.replace(/ajax_user_email/g, response.email)
        li_content = li_content.replace(/ajax_user_id/g, response.id)

        new_li_element = li_open_tag + li_content + li_close_tag

        $('#list_of_users').append($(new_li_element).hide().fadeIn())
        bind_delete_user_button()

  true
