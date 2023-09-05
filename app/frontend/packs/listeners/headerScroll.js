const headerScroll = () => {
  const headerScrollContainer = document.getElementById('header-scroll')
  const headerImage = document.getElementById('header-image')
  const navImage = document.getElementById('nav-image')

  const baseImageHeight = parseInt(
    headerScrollContainer.getAttribute('data-header-scroll-image-height')
  )
  const baseHeaderHeight = parseInt(
    headerScrollContainer.getAttribute('data-header-scroll-header-height')
  )

  const scrollTop = window.pageYOffset || document.documentElement.scrollTop

  let parallaxOffset
  let headerBottomOffset
  let navTopOffset

  if (scrollTop < baseImageHeight - baseHeaderHeight) {
    parallaxOffset = scrollTop / 3.5
    headerBottomOffset = `${-parallaxOffset}px`
    navTopOffset = `${-(scrollTop - parallaxOffset)}px`
  } else {
    parallaxOffset = (baseImageHeight - baseHeaderHeight) / 3.5
    headerBottomOffset = `${-parallaxOffset}px`
    navTopOffset = `${-(baseImageHeight - baseHeaderHeight - parallaxOffset)}px`
  }

  window.requestAnimationFrame(() => {
    headerImage.style.bottom = headerBottomOffset
    navImage.style.top = navTopOffset
  })
}

export default headerScroll
