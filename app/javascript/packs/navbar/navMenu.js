export default function navMenuClick() {
  var hamburger_container = document.querySelector('.hamburger_container')

  function openMenu() {
    this.parentElement.querySelector('.nav_item_container').style.display = 'flex'
    document.querySelector('.page_container').style.left = '-160px';
    this.removeEventListener('click', openMenu)
    this.addEventListener('click', closeMenu)
  }

  function closeMenu() {
    this.parentElement.querySelector('.nav_item_container').style.display = 'none'
    document.querySelector('.page_container').style.left = '0px';
    this.removeEventListener('click', closeMenu)
    this.addEventListener('click', openMenu)
  }

  hamburger_container.addEventListener('click', openMenu)
}