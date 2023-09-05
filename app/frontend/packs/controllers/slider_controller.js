import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['input', 'value']

  update() {
    this.valueTarget.innerHTML = this.inputTarget.value
  }
}
