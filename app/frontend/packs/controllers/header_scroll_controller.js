import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['headerImage']

  connect () {
    this.baseImageHeight = parseInt(this.data.get('imageHeight'))
    this.baseHeaderHeight = parseInt(this.data.get('headerHeight'))
  }

  scrollHeaderImage () {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop
    const headerImages = this.headerImageTargets
    const baseImageHeight = this.baseImageHeight
    const baseHeaderHeight = this.baseHeaderHeight
    window.requestAnimationFrame(() => {
      if (scrollTop < (baseImageHeight - baseHeaderHeight)) {
        for (let i = 0; i < headerImages.length; i++) {
          headerImages[i].style.height = `${baseImageHeight - scrollTop}px`
        }
      } else {
        for (let i = 0; i < headerImages.length; i++) {
          headerImages[i].style.height = `${baseHeaderHeight}px`
        }
      }
    })
  }

  teardown () {
    for (let i = 0; i < this.headerImageTargets.length; i++) {
      this.headerImageTargets[i].style.height = `${this.baseImageHeight}px`
    }
  }

  disconnect () {
    this.teardown()
  }
}
