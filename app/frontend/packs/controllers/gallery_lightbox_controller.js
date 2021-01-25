import { Controller } from 'stimulus'
import SimpleLightbox from 'simplelightbox'

export default class extends Controller {
  connect () {
    this.lightbox = new SimpleLightbox(this.data.get('item-selector'), {
      showCounter: false,
      animationSpeed: 100,
      htmlClass: false,
      animationSlide: false,
      history: false,
      close: false,
      fadeSpeed: 150,
      captionClass: 'lightbox-caption'
    })
  }

  reConnect () {
    this.lightbox.destroy()
    this.connect()
  }

  disconnect () {
    if (this.lightbox) {
      this.lightbox.destroy()
    }
  }
}
