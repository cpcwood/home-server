export default function hamburgerAnimation() { 
  var hamburgerContainers = document.getElementsByClassName('hamburger_container')
  function addAnimation() {
    this.classList.remove('reset_animation')
    this.classList.add('clicked')
    this.removeEventListener('click', addAnimation);
    this.addEventListener('click', addReverseAnimation)
  }
  function addReverseAnimation() {
    this.classList.remove('clicked')
    this.classList.add('reset_animation')
    this.removeEventListener('click', addReverseAnimation)
    this.addEventListener('click', addAnimation)
  }
  for (var i = 0; i < hamburgerContainers.length; i++) {
    hamburgerContainers[i].addEventListener('click', addAnimation)
  }
}

  