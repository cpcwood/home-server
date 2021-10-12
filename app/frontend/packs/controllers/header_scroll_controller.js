import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['headerImage', 'navImage']

  connect () {
    this.baseImageHeight = parseInt(this.data.get('imageHeight'))
    this.baseHeaderHeight = parseInt(this.data.get('headerHeight'))
  }

  scrollHeaderImage () {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop
    const headerImage = this.headerImageTarget
    const navImage = this.navImageTarget
    const baseImageHeight = this.baseImageHeight
    const baseHeaderHeight = this.baseHeaderHeight
    window.requestAnimationFrame(() => {
      if (scrollTop < (baseImageHeight - baseHeaderHeight)) {
        let parallaxOffset = scrollTop/3
        headerImage.style.bottom = `${-parallaxOffset}px`
        navImage.style.top = `${-(scrollTop-parallaxOffset)}px`
      } else {
        let parallaxOffset = (baseImageHeight - baseHeaderHeight)/3
        headerImage.style.bottom = `${-parallaxOffset}px`
        navImage.style.top = `${-((baseImageHeight - baseHeaderHeight)-parallaxOffset)}px`
      }
    })
  }

  teardown () {
    headerImage.style.bottom = `0px`
    navImage.style.top = `0px`
  }

  disconnect () {
    this.teardown()
  }
}
