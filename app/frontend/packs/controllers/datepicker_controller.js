import { Controller } from 'stimulus'
import Pikaday from 'pikaday/pikaday.js'

export default class extends Controller {
  static targets = ['dateField']

  connect () {
    this.datePicker = new Pikaday({ field: this.dateFieldTarget })
  }

  disconnect () {
    this.datePicker.destroy()
  }
}
