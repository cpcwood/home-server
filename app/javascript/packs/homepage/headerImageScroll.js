document.addEventListener('turbolinks:load', function(){
  var headerImage = document.querySelector('.header_image')
  window.addEventListener('scroll', function(e) {
    console.log('scroll')
    console.log(headerImage.offsetHeight)
    if (window.scrollY < 295) {
      headerImage.style.height = `${300 - window.scrollY}px`
      headerImage.style.zIndex = '-1'
    } else {
      headerImage.style.height = '5px'
      headerImage.style.zIndex = '1'
    }
    console.log(window.scrollY)
  })
})