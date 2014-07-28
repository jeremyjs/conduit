$ ->
  $('.fullpage').fullpage
    navigation: true
    verticalCentered: false
    keyboardScrolling: false
    normalScrollElements: '.panel-body, .selectize-dropdown-content'
    afterLoad: (anchorLink, index) ->
      window.currentPage = index

  $('.menu-link').bigSlide()
  window.currentPage = 1
