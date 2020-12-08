import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['fade', 'container']

  fadeInTargets () {
    this.fadeInTimeout = setTimeout(() => {
      for (let i = 0; i < this.fadeTargets.length; i++) {
        const target = this.fadeTargets[i]
        target.style.transitionDelay = `${i * 0.1}s`
        target.classList.add('fade-in')
      }
    }, 1)
  }

  isImageLoadRequired () {
    const numberOfImages = this.containerTarget.getElementsByTagName('img').length
    if (numberOfImages === 0 && !this.isPreview) {
      this.fadeInTargets()
      return false
    }
    return true
  }

  evaluateImageLoad () {
    if (this.imageCounter === this.targetNumber && !this.isPreview) {
      this.fadeInTargets()
    }
  }

  connect () {
    this.targetNumber = this.fadeTargets.length
    const numberOfLoadedImages = this.fadeTargets.reduce((acc, img) => img.complete && img.naturalHeight !== 0 ? ++acc : acc, 0)
    this.imageCounter = numberOfLoadedImages
    if (this.isImageLoadRequired()) {
      this.evaluateImageLoad()
    }
  }

  imageLoaded () {
    this.imageCounter += 1
    this.evaluateImageLoad()
  }

  teardown () {
    if (this.fadeInTimeout) {
      clearTimeout(this.fadeInTimeout)
    }
    for (let i = 0; i < this.fadeTargets.length; i++) {
      const target = this.fadeTargets[i]
      target.classList.remove('fade-in')
      target.style.transitionDelay = null
    }
  }

  disconnect () {
    this.teardown()
  }

  get isPreview () {
    return document.documentElement.hasAttribute('data-turbolinks-preview')
  }
}
