import { Controller } from 'stimulus'
import SimpleLightbox from 'simplelightbox'

export default class extends Controller {
  static targets = ['container']

  initialize () {
    this.lightbox = new SimpleLightbox(this.data.get('item-selector'), {})
  }

  disconnect () {

  }
}
