import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['image', 'container']

  get position () {
    let currentPosition = parseInt(this.data.get('position'))
    if (currentPosition < -this.imageTargets.length || isNaN(currentPosition)) {
      currentPosition = 0
    }
    return (currentPosition + this.imageTargets.length) % this.imageTargets.length
  }

  set position (newPosition) {
    this.data.set('position', Math.abs((newPosition + this.imageTargets.length) % this.imageTargets.length))
  }

  quickDisplayCurrentImage () {
    this.imageTargets[this.position].style.display = 'block'
  }

  resetOtherImages () {
    const currentPosition = this.position
    for (let i = 0; i < this.imageTargets.length; i += 1) {
      if (i !== currentPosition) {
        this.imageTargets[i].style.display = 'none'
      }
    }
  }

  connect () {
    this.quickDisplayCurrentImage()
    this.resetOtherImages()
  }

  next () {
    this.position += 1
    this.quickDisplayCurrentImage()
    this.resetOtherImages()
  }

  prev () {
    this.position -= 1
    this.quickDisplayCurrentImage()
    this.resetOtherImages()
  }
}
