import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['fade', 'container']

  initialize () {
    this.targetNumber = this.containerTarget.getElementsByTagName('img').length
    this.imageCounter = 0
  }

  imageLoaded () {
    this.imageCounter += 1
    if (this.imageCounter === this.targetNumber) {
      for (let i = 0; i < this.fadeTargets.length; i++) {
        const target = this.fadeTargets[i]
        target.classList.add('fade-in')
        target.style.transitionDelay = `${i * 0.1}s`
      }
    }
  }

  disconnect () {
    for (let i = 0; i < this.fadeTargets.length; i++) {
      const target = this.fadeTargets[i]
      target.classList.remove('fade-in')
      target.style.transitionDelay = ''
    }
  }
}
