import { Controller } from '@hotwired/stimulus'
import justifiedLayout from 'justified-layout'

export default class extends Controller {
  static targets = ['galleryItem']

  connect () {
    this.evaluateLoadProgress()
  }

  evaluateLoadProgress () {
    const allImagesLoaded = this.galleryItemTargets.every(img => img.complete && img.naturalHeight !== 0)
    if (allImagesLoaded) {
      this.displayGalleryItemTargets()
    }
  }

  displayGalleryItemTargets () {
    const fadeIn = () => {
      this.resizeObserver = new ResizeObserver(this.renderGallery.bind(this))
      this.resizeObserver.observe(this.element)
      for (let i = 0; i < this.galleryItemTargets.length; i++) {
        const target = this.galleryItemTargets[i]
        target.style.transitionDelay = `${i * 0.1}s`
        target.classList.add('fade-in')
      }
      this.element.dispatchEvent(new Event('galleryRendered'))
    }
    this.fadeInTimeout = setTimeout(fadeIn, 1)
  }

  renderGallery () {
    try {
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
        containerWidth: this.element.clientWidth,
        targetRowHeight: 295
      }
      const geometry = justifiedLayout(geometryInput, config)
      window.requestAnimationFrame(() => {
        for (let i = 0; i < this.galleryItemTargets.length; i++) {
          this.galleryItemTargets[i].width = geometry.boxes[i].width
          this.galleryItemTargets[i].height = geometry.boxes[i].height
        }
      })
    } catch (error) {
      console.log(error)
    }
  }

  imageLoaded () {
    this.imagesLoadedCounter += 1
    this.evaluateLoadProgress()
  }

  teardown () {
    if (this.fadeInTimeout) {
      clearTimeout(this.fadeInTimeout)
    }
    if (this.resizeObserver) {
      this.resizeObserver.disconnect()
    }
    while (this.element.firstChild) { this.element.removeChild(this.element.firstChild) }
  }

  disconnect () {
    this.teardown()
  }
}
