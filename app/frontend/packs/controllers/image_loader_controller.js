import { Controller } from 'stimulus'
// asd
export default class extends Controller {
  static targets = ['fade', 'container']

  connect () {
    this.numberOfTargets = this.fadeTargets.length
    this.imagesLoadedCounter = this.fadeTargets.reduce((acc, target) => {
      const image = target.tagName === 'IMG' ? target : target.querySelector('img')
      if (!image) {
        return ++acc
      }
      return image.complete && image.naturalHeight !== 0 ? ++acc : acc
    }, 0)
    this.evaluateLoadProgress()
  }

  evaluateLoadProgress () {
    if (this.imagesLoadedCounter === this.numberOfTargets && !this.isPreview) {
      this.fadeInTargets()
    }
  }

  fadeInTargets () {
    const fadeIn = () => {
      for (let i = 0; i < this.fadeTargets.length; i++) {
        const target = this.fadeTargets[i]
        target.style.transitionDelay = `${i * 0.1}s`
        target.classList.add('fade-in')
        this.fadeInTimeout = null
      }
    }
    this.fadeInTimeout = setTimeout(fadeIn, 1)
  }

  imageLoaded () {
    this.imagesLoadedCounter += 1
    this.evaluateLoadProgress()
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
