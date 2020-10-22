import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['fade', 'container']

  initialize () {
    this.targetNumber = this.containerTarget.getElementsByTagName('img').length
    this.imageCounter = 0
  }

  imageLoaded (event) {
    this.imageCounter += 1
    if (this.imageCounter === this.targetNumber) {
      for (let i = 0; i < this.fadeTargets.length; i++) {
        this.fadeTargets[i].classList.add('fade-in')
      }
    }
  }

  disconnect () {
    this.imageCounter = 0
    this.targetNumber = 0
    for (let i = 0; i < this.fadeTargets.length; i++) {
      this.fadeTargets[i].classList.remove('fade-in')
    }
  }
}
