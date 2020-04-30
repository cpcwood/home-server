import hamburgerAnimation from './navbar/hamburger.js'
import navMenuClick from './navbar/navMenu.js'
import touchHover from './touch/touchHover.js'

document.addEventListener('turbolinks:load', function(){
  hamburgerAnimation()
  navMenuClick()
  touchHover()
})