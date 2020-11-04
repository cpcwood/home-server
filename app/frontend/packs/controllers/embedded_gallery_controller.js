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
    const currentImage = this.imageTargets[this.position]
    currentImage.style.transition = ''
    currentImage.style.opacity = '1'
    currentImage.style.transition = `opacity ${this.transitionDuration / 1000}s cubic-bezier(0.76, 0.24, 0.26, 0.99)`
  }

  applyBaseStylesToImages () {
    for (let i = 0; i < this.imageTargets.length; i += 1) {
      const image = this.imageTargets[i]
      image.style.transition = `opacity ${this.transitionDuration / 1000}s cubic-bezier(0.76, 0.24, 0.26, 0.99)`
      image.style.opacity = '0'
      image.style.display = 'block'
      image.style.position = 'absolute'
    }
  }

  fadeOutOriginalImage (originalPosition) {
    const originalImage = this.imageTargets[originalPosition]
    originalImage.style.opacity = '0'
    this.fadeInNextImageTimeout = setTimeout(this.fadeInNextImage.bind(this), Math.floor(this.transitionDuration * 0.25))
  }

  fadeInNextImage () {
    const nextImage = this.imageTargets[this.position]
    nextImage.style.opacity = '1'
    this.fadeInCompleteTimeout = setTimeout(this.fadeInComplete.bind(this), this.transitionDuration)
    this.fadeInNextImageTimeout = null
  }

  fadeInComplete () {
    this.fadeInCompleteTimeout = null
  }

  initialize () {
    this.transitionDuration = 450
  }

  connect () {
    this.fadeInNextImageTimeout = null
    this.fadeInCompleteTimeout = null
    this.applyBaseStylesToImages()
    this.quickDisplayCurrentImage()
  }

  next () {
    const originalPosition = this.position
    this.position += 1
    if (!this.fadeInNextImageTimeout) {
      this.fadeOutOriginalImage(originalPosition)
    }
  }

  prev () {
    const originalPosition = this.position
    this.position -= 1
    if (!this.fadeInNextImageTimeout) {
      this.fadeOutOriginalImage(originalPosition)
    }
  }

  teardown () {
    this.position = 0
    if (this.fadeInNextImageTimeout) {
      clearTimeout(this.fadeInNextImageTimeout)
      this.fadeInNextImageTimeout = null
    }
    if (this.fadeInCompleteTimeout) {
      clearTimeout(this.fadeInCompleteTimeout)
      this.fadeInCompleteTimeout = null
    }
    this.applyBaseStylesToImages()
    this.quickDisplayCurrentImage()
  }

  disconnect () {
    this.teardown()
  }
}
