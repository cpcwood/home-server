import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['fade', 'container']
  static values = {
    loadTimeout: { type: Number, default: 10000 },
    tileSelector: { type: String, default: '' }
  }

  connect () {
    this.loadTimeoutId = setTimeout(() => this.forceResolve(), this.loadTimeoutValue)
    this.evaluateLoadProgress()
  }

  imageLoaded () {
    this.evaluateLoadProgress()
  }

  imageError (event) {
    this.markFailed(event.target)
    this.evaluateLoadProgress()
  }

  evaluateLoadProgress () {
    let allResolved = true
    this.fadeTargets.forEach(target => {
      const image = this.imageFor(target)
      if (!image) {
        return
      }
      if (!image.complete) {
        allResolved = false
        this.clearFailed(image)
      } else if (image.naturalHeight === 0) {
        this.markFailed(image)
      } else {
        this.clearFailed(image)
      }
    })
    if (allResolved) {
      this.clearLoadTimeout()
      this.fadeInTargets()
    }
  }

  forceResolve () {
    this.loadTimeoutId = null
    this.element.classList.add('load-timed-out')
    this.fadeTargets.forEach(target => {
      const image = this.imageFor(target)
      if (image && (!image.complete || image.naturalHeight === 0)) {
        this.markFailed(image)
      }
    })
    this.fadeInTargets()
  }

  imageFor (target) {
    return target.tagName === 'IMG' ? target : target.querySelector('img')
  }

  tileFor (image) {
    if (this.tileSelectorValue) {
      return image.closest(this.tileSelectorValue)
    }
    return this.fadeTargets.find(target => target === image || target.contains(image))
  }

  markFailed (image) {
    const tile = this.tileFor(image)
    if (tile) {
      tile.classList.add('load-failed')
    }
  }

  clearFailed (image) {
    const tile = this.tileFor(image)
    if (tile) {
      tile.classList.remove('load-failed')
    }
  }

  fadeInTargets () {
    clearTimeout(this.fadeInTimeout)
    this.fadeInTimeout = setTimeout(() => {
      this.fadeInTimeout = null
      this.fadeInFrameId = window.requestAnimationFrame(() => {
        this.fadeInFrameId = null
        for (let i = 0; i < this.fadeTargets.length; i++) {
          const target = this.fadeTargets[i]
          target.style.transitionDelay = `${i * 0.1}s`
          target.classList.add('fade-in')
        }
      })
    }, 1)
  }

  clearLoadTimeout () {
    if (this.loadTimeoutId) {
      clearTimeout(this.loadTimeoutId)
      this.loadTimeoutId = null
    }
  }

  teardown () {
    clearTimeout(this.fadeInTimeout)
    this.fadeInTimeout = null
    if (this.fadeInFrameId) {
      window.cancelAnimationFrame(this.fadeInFrameId)
      this.fadeInFrameId = null
    }
    this.element.classList.remove('load-timed-out')
    for (let i = 0; i < this.fadeTargets.length; i++) {
      const target = this.fadeTargets[i]
      target.classList.remove('fade-in')
      target.style.transitionDelay = null
      const image = this.imageFor(target)
      if (image) {
        this.clearFailed(image)
      }
    }
  }

  disconnect () {
    this.clearLoadTimeout()
    this.teardown()
  }
}
