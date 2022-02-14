import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['headerImage', 'navImage']

  connect () {
    this.baseImageHeight = parseInt(this.data.get('imageHeight'))
    this.baseHeaderHeight = parseInt(this.data.get('headerHeight'))
  }

  scrollHeaderImage () {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop
    const baseImageHeight = this.baseImageHeight
    const baseHeaderHeight = this.baseHeaderHeight

    let parallaxOffset
    let headerBottomOffset
    let navTopOffset

    if (scrollTop < (baseImageHeight - baseHeaderHeight)) {
      parallaxOffset = scrollTop / 3.5
      headerBottomOffset = `${-parallaxOffset}px`
      navTopOffset = `${-(scrollTop - parallaxOffset)}px`
    } else {
      parallaxOffset = (baseImageHeight - baseHeaderHeight) / 3.5
      headerBottomOffset = `${-parallaxOffset}px`
      navTopOffset = `${-((baseImageHeight - baseHeaderHeight) - parallaxOffset)}px`
    }

    window.requestAnimationFrame(() => {
      this.headerImageTarget.style.bottom = headerBottomOffset
      this.navImageTarget.style.top = navTopOffset
    })
  }

  teardown () {
    this.headerImageTarget.style.bottom = '0px'
    this.navImageTarget.style.top = '0px'
  }

  disconnect () {
    this.teardown()
  }
}
