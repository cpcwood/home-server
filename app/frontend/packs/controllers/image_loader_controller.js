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
        let target = this.fadeTargets[i]
        target.classList.add('fade-in')
        target.style["transitionDelay"] = `${i*0.1}s`
      }
    }
  }

  disconnect () {
    this.imageCounter = 0
    this.targetNumber = 0
    for (let i = 0; i < this.fadeTargets.length; i++) {
      let target = this.fadeTargets[i]
      target.classList.remove('fade-in')
      target.style["transitionDelay"] = '0'
    }
  }
}
