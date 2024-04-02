import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['navButton', 'image', 'container']

  connect () {
    this.transitionDuration = 450
    this.fadeInNextImageTimeout = null
    this.fadeInCompleteTimeout = null
    this.applyBaseStylesToImages()
    this.quickDisplayCurrentImage()
    this.addNavButtons()
  }

  next () {
    const originalPosition = this.position
    this.position += 1
    this.transitionToNextImage(originalPosition)
  }

  prev () {
    const originalPosition = this.position
    this.position -= 1
    this.transitionToNextImage(originalPosition)
  }

  teardown () {
    this.position = 0
    if (this.fadeInNextImageTimeout) {
      clearTimeout(this.fadeInNextImageTimeout)
      this.fadeInNextImageTimeout = null
    }
    if (this.transitionCompleteTimeout) {
      clearTimeout(this.transitionCompleteTimeout)
      this.transitionCompleteTimeout = null
    }
    this.resetOtherImages()
    this.quickDisplayCurrentImage()
    this.hideNavButtons()
  }

  disconnect () {
    this.teardown()
  }

  // private

  applyBaseStylesToImages () {
    for (let i = 0; i < this.imageTargets.length; i += 1) {
      const image = this.imageTargets[i]
      image.style.transition = `opacity ${this.transitionDuration / 1000}s cubic-bezier(0.76, 0.24, 0.26, 0.99)`
      image.style.opacity = '0'
      image.style.display = 'block'
      image.style.position = 'absolute'
    }
  }

  quickDisplayCurrentImage () {
    const currentImage = this.imageTargets[this.position]
    currentImage.style.transition = ''
    currentImage.style.opacity = '1'
    currentImage.style.zIndex = '1'
    currentImage.style.transition = `opacity ${this.transitionDuration / 1000}s cubic-bezier(0.76, 0.24, 0.26, 0.99)`
  }

  addNavButtons () {
    if (this.imageTargets.length > 1) {
      for (let i = 0; i < this.navButtonTargets.length; i += 1) {
        const navButton = this.navButtonTargets[i]
        navButton.style.display = 'flex'
      }
    }
  }

  transitionToNextImage (originalPosition) {
    if (!this.fadeInNextImageTimeout) {
      if (!this.transitionCompleteTimeout) {
        this.fadeOutOriginalImage(originalPosition)
      } else {
        this.resetOtherImages()
        this.quickDisplayCurrentImage()
        clearTimeout(this.transitionCompleteTimeout)
        this.transitionCompleteTimeout = null
      }
    }
  }

  fadeOutOriginalImage (originalPosition) {
    const originalImage = this.imageTargets[originalPosition]
    originalImage.style.opacity = '0'
    originalImage.style.zIndex = null
    this.fadeInNextImageTimeout = setTimeout(this.fadeInNextImage.bind(this), Math.floor(this.transitionDuration * 0.1))
  }

  fadeInNextImage () {
    const nextImage = this.imageTargets[this.position]
    nextImage.style.opacity = '1'
    nextImage.style.zIndex = '1'
    this.transitionCompleteTimeout = setTimeout(this.transitionComplete.bind(this), this.transitionDuration)
    this.fadeInNextImageTimeout = null
  }

  resetOtherImages () {
    const currentImageId = this.position
    for (let i = 0; i < this.imageTargets.length; i += 1) {
      if (i !== currentImageId) {
        const image = this.imageTargets[i]
        image.style.transition = ''
        image.style.opacity = '0'
        image.style.zIndex = null
        image.style.transition = `opacity ${this.transitionDuration / 1000}s cubic-bezier(0.76, 0.24, 0.26, 0.99)`
      }
    }
  }

  transitionComplete () {
    this.transitionCompleteTimeout = null
  }

  hideNavButtons () {
    for (let i = 0; i < this.navButtonTargets.length; i += 1) {
      const navButton = this.navButtonTargets[i]
      navButton.style.display = 'none'
    }
  }

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
}
