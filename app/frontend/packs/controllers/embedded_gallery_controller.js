import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['image', 'container']

  connect () {

  }

  teardown () {

  }

  disconnect () {
    this.teardown()
  }
}
