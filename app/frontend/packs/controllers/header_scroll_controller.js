import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['headerImage', 'contentContainer']

  scrollHeaderImage () {
    if (this.contentContainerTarget.scrollTop < 240) {
      this.headerImageTarget.style.height = `${300 - this.contentContainerTarget.scrollTop}px`
      this.headerImageTarget.style.zIndex = '-1'
    } else {
      this.headerImageTarget.style.height = '60px'
      this.headerImageTarget.style.zIndex = '2'
    }
  }

  disconnect () {
    this.headerImageTarget.style.height = 300
  }
}
