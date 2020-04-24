// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

require('packs/navbar/hamburger')
require('packs/navbar/navMenu')

import hamburgerAnimation from './navbar/hamburger.js'
import navMenuClick from './navbar/navMenu.js'

window.addEventListener('load', function(){
  hamburgerAnimation()
  navMenuClick()
})