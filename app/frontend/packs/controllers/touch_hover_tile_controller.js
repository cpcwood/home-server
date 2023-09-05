import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['coverTitle']

  touchStart() {
    this.touchTime = new Date(Date.now())
  }

  touchEnd(event) {
    const diff = new Date(Date.now()) - this.touchTime
    if (diff < 250) {
      this.applyHoverToTarget(event)
    }
  }

  applyHoverToTarget(event) {
    if (!this.coverTitleTarget.classList.contains('hover')) {
      const otherHoverTiles = document.getElementsByClassName('hover')
      for (let i = 0; i < otherHoverTiles.length; i += 1) {
        otherHoverTiles[i].classList.remove('hover')
      }
      this.coverTitleTarget.classList.add('hover')
      event.preventDefault()
    }
  }

  teardown() {
    this.coverTitleTarget.classList.remove('hover')
  }

  disconnect() {
    this.teardown()
  }
}
