import { Controller } from 'stimulus'
import SimpleLightbox from 'simplelightbox'

export default class extends Controller {
  static targets = ['container']

  initialize () {
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
}
