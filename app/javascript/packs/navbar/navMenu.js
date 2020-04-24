export default function navMenuClick() {
  var hamburger_container = document.querySelector('.hamburger_container')

  function openMenu() {
    this.parentElement.querySelector('.nav_item_container').classList.add('sidebar_open')
    this.removeEventListener('click', openMenu)
    this.addEventListener('click', closeMenu)
  }

  function closeMenu() {
    this.parentElement.querySelector('.nav_item_container').classList.remove('sidebar_open')
    this.removeEventListener('click', closeMenu)
    this.addEventListener('click', openMenu)
  }

  hamburger_container.addEventListener('click', openMenu)
}