import { Controller } from '@hotwired/stimulus'
// asd
export default class extends Controller {
  static targets = ['fade', 'container']
  static values = { loadTimeout: { type: Number, default: 10000 } }

  connect () {
    this.loadTimeoutId = setTimeout(() => {
      this.element.classList.add('load-timed-out')
    }, this.loadTimeoutValue)
    this.evaluateLoadProgress()
  }

  imageLoaded () {
    this.evaluateLoadProgress()
  }

  evaluateLoadProgress () {
    const allImagesLoaded = this.fadeTargets.every(target => {
      const image = target.tagName === 'IMG' ? target : target.querySelector('img')
      if (!image) {
        return true
      }
      return image.complete && image.naturalHeight !== 0
    })
    if (allImagesLoaded) {
      this.clearLoadTimeout()
      this.fadeInTargets()
    }
  }

  fadeInTargets () {
    const fadeIn = () => {
      window.requestAnimationFrame(() => {
        for (let i = 0; i < this.fadeTargets.length; i++) {
          const target = this.fadeTargets[i]
          target.style.transitionDelay = `${i * 0.1}s`
          target.classList.add('fade-in')
          this.fadeInTimeout = null
        }
      })
    }
    this.fadeInTimeout = setTimeout(fadeIn, 1)
  }

  clearLoadTimeout () {
    if (this.loadTimeoutId) {
      clearTimeout(this.loadTimeoutId)
      this.loadTimeoutId = null
    }
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
    this.clearLoadTimeout()
    this.teardown()
  }
}
