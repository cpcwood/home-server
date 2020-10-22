import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['galleryItem', 'container']

  initialize () {
    this.targetNumber = this.containerTarget.getElementsByTagName('img').length
    this.imageCounter = 0
    this.targetRowHeight = 350
    // add event listener for window resize to trigger render gallery
  }

  imageLoaded (event) {
    this.imageCounter += 1
    if (this.imageCounter === this.targetNumber) {
      // render gallery
      this.renderGallery()
      
      // fade in
      for (let i = 0; i < this.galleryItemTargets.length; i++) {
        let target = this.galleryItemTargets[i]
        target.classList.add('fade-in')
        target.style["transitionDelay"] = `${i*0.1}s`
      }
    }
  }

  renderGallery() {
    // fetch image sizes
    console.log(this.galleryItemTarget.width)
    // fetch container size
    console.log(this.containerTarget.clientWidth)
    // compute sizes using plugin
    // apply sizes
    // return
  }

  disconnect () {
    this.imageCounter = 0
    this.targetNumber = 0
    for (let i = 0; i < this.fadeTargets.length; i++) {
      let target = this.galleryItemTargets[i]
      target.classList.remove('fade-in')
      target.style["transitionDelay"] = '0'
    }
  }
}
