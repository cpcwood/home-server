export default function navMenuClick() {
  var hamburger_container = document.querySelector('.hamburger_container')

  function openMenu() {
    let navMenu = this.parentElement
    navMenu.querySelector('.nav_item_container').classList.add('sidebar_open')
    this.removeEventListener('click', openMenu)
    this.addEventListener('click', closeMenu)
  }

  function closeMenu() {
    let navMenu = this.parentElement
    navMenu.querySelector('.nav_item_container').classList.remove('sidebar_open')
    this.removeEventListener('click', closeMenu)
    this.addEventListener('click', openMenu)
  }

  hamburger_container.addEventListener('click', openMenu)
}