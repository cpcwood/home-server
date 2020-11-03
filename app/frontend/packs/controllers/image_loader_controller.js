import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['fade', 'container']

  fadeInTargets () {
    for (let i = 0; i < this.fadeTargets.length; i++) {
      const target = this.fadeTargets[i]
      target.classList.add('fade-in')
      target.style.transitionDelay = `${i * 0.1}s`
    }
  }

  initialize () {
    this.targetNumber = this.fadeTargets.length
    this.imageCounter = 0
    const numberOfImages = this.containerTarget.getElementsByTagName('img').length
    if (numberOfImages === 0) {
      this.fadeInTargets()
    }
  }

  imageLoaded () {
    this.imageCounter += 1
    if (this.imageCounter === this.targetNumber) {
      this.fadeInTargets()
    }
  }

  teardown () {
    for (let i = 0; i < this.fadeTargets.length; i++) {
      const target = this.fadeTargets[i]
      target.classList.remove('fade-in')
      target.style.transitionDelay = null
    }
  }

  disconnect () {
    this.teardown()
  }
}
