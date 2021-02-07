import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['headerImage', 'contentContainer']

  connect () {
    this.contentContainerTarget.scrollTop = 0
    this.baseImageHeight = parseInt(this.data.get('imageHeight'))
    this.baseHeaderHeight = parseInt(this.data.get('headerHeight'))
  }

  scrollHeaderImage () {
    window.requestAnimationFrame(() => {
      if (this.contentContainerTarget.scrollTop < (this.baseImageHeight - this.baseHeaderHeight)) {
        this.headerImageTarget.style.height = `${this.baseImageHeight - this.contentContainerTarget.scrollTop}px`
        this.headerImageTarget.style.zIndex = '-1'
      } else {
        this.headerImageTarget.style.height = `${this.baseHeaderHeight}px`
        this.headerImageTarget.style.zIndex = '2'
      }
    });
  }

  teardown () {
    this.contentContainerTarget.scrollTop = 0
    this.headerImageTarget.style.height = `${this.baseImageHeight}px`
    this.headerImageTarget.style.zIndex = '-1'
  }

  disconnect () {
    this.teardown()
  }
}
