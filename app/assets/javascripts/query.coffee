$ ->
  if $('#query_command').length
    myCodeMirror = CodeMirror.fromTextArea query_command,
      lineNumbers: true
      mode: 'text/x-sql'
      theme: 'neo'
  if $('#query_show_command').length
    myReadOnlyCodeMirror = CodeMirror.fromTextArea query_show_command,
      lineNumbers: true
      mode: 'text/x-sql'
      theme: 'neo'
      readOnly: true
