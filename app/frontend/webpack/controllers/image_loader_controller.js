import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['fade']

  initialize () {
    this.imageCounter = 0
  }

  imageLoaded (event) {
    const targetNumber = parseInt(this.data.get('num-images'))
    this.imageCounter += 1
    if (this.imageCounter === targetNumber) {
      for (let i = 0; i < this.fadeTargets.length; i++) {
        this.fadeTargets[i].classList.add('fade-in')
      }
    }
  }

  disconnect () {
    this.imageCounter = 0
    for (let i = 0; i < this.fadeTargets.length; i++) {
      this.fadeTargets[i].classList.remove('fade-in')
    }
  }
}
