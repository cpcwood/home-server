require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

require('packs/navbar/hamburger')
require('packs/navbar/navMenu')
require('packs/touch/touchHover')

import hamburgerAnimation from './navbar/hamburger.js'
import navMenuClick from './navbar/navMenu.js'
import touchHover from './touch/touchHover.js'

document.addEventListener('turbolinks:load', function(){
  hamburgerAnimation()
  navMenuClick()
  touchHover()
})