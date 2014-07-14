$ ->
  $('.fullpage').fullpage
    navigation: true
    verticalCentered: false
    normalScrollElements: '.panel-body'
    afterLoad: (anchorLink, index) ->
      window.currentPage = index

  $('.menu-link').bigSlide()
  window.currentPage = 1
