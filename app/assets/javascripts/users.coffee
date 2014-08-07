$ ->
  $('#map_roles').click ->
    $.ajax
      type: 'post'
      url: "/ldap_role_mappings"
      data:
        ldap_group: $("#ldap-group-select").val()
        role: $("#role-select").val()

  $('#map_users').click ->
    mappings = {}
    $('#list_of_users>li>input').each ->
      if mappings[$(this).attr('user')] == undefined
        mappings[$(this).attr('user')] = ['nil']
      if $(this).is(':checked')
        mappings[$(this).attr('user')].push $(this).attr('value')

    $.ajax
      type: 'patch'
      url: '/user_role_mappings'
      data:
        mappings: mappings

  $('.delete_user').click ->
    email = $(this).parent().find('.user-email').text()
    if confirm('Are you sure you want to delete '+email+'?')
      $.ajax
        type: 'delete'
        url: '/delete_user'
        data:
          email: email

  $('.delete_mapping').click ->
    mapping_id = $(this).parent().find('.ldap-mapping-group').attr('mapping_id')
    if confirm('Are you sure you want to delete this LDAP mapping?')
      $.ajax
        type: 'delete'
        url: '/delete_ldap_mapping'
        data: 
          mapping_id: mapping_id
