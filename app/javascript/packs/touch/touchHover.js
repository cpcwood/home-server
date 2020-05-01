export default function touchHover() {
  var touchItems = document.getElementsByClassName('homepage_item')
  var touchTime = 0

  function touchStartTime(e) {
    touchTime = new Date()
  }
  
  function addHoverEffect(e) {
    var diff = new Date() - touchTime
    if (diff < 300) {
      var coverTitle = this.querySelector('.cover_title')
      if (!coverTitle.classList.contains('hover')) {
        var otherHover = document.querySelector('.hover')
        if (otherHover) otherHover.classList.remove('hover')
        coverTitle.classList.add('hover')
        e.preventDefault()
      }
    }
  }

  for (var i = 0; i < touchItems.length; i++) {
    touchItems[i].addEventListener('touchstart', touchStartTime)
    touchItems[i].addEventListener('touchend', addHoverEffect)
  }
}


