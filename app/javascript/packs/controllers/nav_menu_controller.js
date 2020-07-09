import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['navHamburger', 'navSidebar']

  menuToggle () {
    if (this.data.get('open') === 'false') {
      this.openMenu()
    } else {
      this.closeMenu()
    }
  }

  openMenu () {
    this.data.set('open', 'true')
    this.navSidebarTarget.classList.add('sidebar_open')
    this.navHamburgerTarget.classList.add('clicked')
    this.navHamburgerTarget.classList.remove('reset_animation')
  }

  closeMenu () {
    this.data.set('open', 'false')
    this.navSidebarTarget.classList.remove('sidebar_open')
    this.navHamburgerTarget.classList.remove('clicked')
    this.navHamburgerTarget.classList.add('reset_animation')
  }

  disconnect () {
    this.closeMenu()
  }
}
