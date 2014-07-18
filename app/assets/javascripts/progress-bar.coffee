$ ->
  $(document).ajaxStart ->
    NProgress.configure
      showSpinner: false

    NProgress.start()

  $(document).ajaxStop ->
    delay 1500, NProgress.done()
