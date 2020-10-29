import { Controller } from 'stimulus'
import justifiedLayout from 'justified-layout'

export default class extends Controller {
  static targets = ['galleryItem', 'container']

  initialize () {
    this.targetNumber = this.containerTarget.getElementsByTagName('img').length
    this.imageCounter = 0
  }

  imageLoaded () {
    this.imageCounter += 1
    if (this.imageCounter === this.targetNumber) {
      this.resizeObserver = new ResizeObserver(this.renderGallery.bind(this)).observe(this.containerTarget)
      for (let i = 0; i < this.galleryItemTargets.length; i++) {
        const target = this.galleryItemTargets[i]
        target.classList.add('fade-in')
        target.style.transitionDelay = `${i * 0.1}s`
      }
    }
  }

  renderGallery () {
    const geometryInput = []
    for (let i = 0; i < this.galleryItemTargets.length; i++) {
      geometryInput.push({
        width: this.galleryItemTargets[i].width,
        height: this.galleryItemTargets[i].height
      })
    }
    const config = {
      boxSpacing: {
        horizontal: parseInt(this.data.get('margin')),
        vertical: 0
      },
      containerWidth: this.containerTarget.clientWidth,
      targetRowHeight: 302
    }
    const geometry = justifiedLayout(geometryInput, config)
    for (let i = 0; i < this.galleryItemTargets.length; i++) {
      this.galleryItemTargets[i].width = geometry.boxes[i].width
      this.galleryItemTargets[i].height = geometry.boxes[i].height
    }
  }

  teardown () {
    if (this.resizeObserver) {
      this.resizeObserver.disconnect()
    }
    for (let i = 0; i < this.galleryItemTargets.length; i++) {
      const target = this.galleryItemTargets[i]
      target.classList.remove('fade-in')
      target.style.transitionDelay = null
    }
  }

  disconnect () {
    this.teardown()
  }
}
