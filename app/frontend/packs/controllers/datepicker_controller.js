import { Controller } from 'stimulus'
const Pikaday = require('pikaday-momentless')

export default class extends Controller {
  static targets = ['dateField']

  connect () {
    this.datePicker = new Pikaday({ field: this.dateFieldTarget })
  }

  disconnect () {
    this.datePicker.destroy()
  }
}
