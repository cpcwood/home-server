import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['sidebar', 'sidebarToggle']

  sidebarToggle () {
    if (this.data.get('open') === 'false') {
      this.openMenu()
    } else {
      this.closeMenu()
    }
  }

  openMenu () {
    this.data.set('open', 'true')
    this.sidebarToggleTarget.classList.add('open')
    this.sidebarTarget.classList.add('open')
  }

  closeMenu () {
    this.data.set('open', 'false')
    this.sidebarToggleTarget.classList.remove('open')
    this.sidebarTarget.classList.remove('open')
  }

  disconnect () {
    this.closeMenu()
  }
}
