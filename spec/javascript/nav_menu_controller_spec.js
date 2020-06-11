import { Application } from 'stimulus'
import navMenuController from 'controllers/nav_menu_controller'
const fs = require('fs')

describe("nav_menu_controller", () => {
  let navHamburger
  let navSidebar
  let navScreenCover
  let navMenu
  let applicationHTML

  beforeAll(done => {
    const application = Application.start()
    application.register("nav-menu", navMenuController)
    fs.readFile("app/views/layouts/_navigation.html.erb", 'utf8', (err, data) => {
      applicationHTML = data
      done()
    })
  })

  beforeEach(() => {
    document.body.innerHTML = applicationHTML
    navMenu = document.querySelector(".nav_menu")
    navHamburger = document.querySelector(".hamburger_container")
    navSidebar = document.querySelector(".nav_sidebar")
    navScreenCover = document.querySelector(".nav_screen_cover")
  })

  describe("#menuToggle - navHamburger click", () => {
    it("toggles menu open status", () => {
      expect(navMenu.getAttribute('data-nav-menu-open')).toEqual('false')
      navHamburger.click()
      expect(navMenu.getAttribute('data-nav-menu-open')).toEqual('true')
      navHamburger.click()
      expect(navMenu.getAttribute('data-nav-menu-open')).toEqual('false')
    })

    it("adds and removes navSidebar 'sidebar_open' class", () => {
      navHamburger.click()
      expect(navSidebar.classList).toContain('sidebar_open')
      navHamburger.click()
      expect(navSidebar.classList).not.toContain('sidebar_open')
    })

    it("adds and removes navHamburger 'clicked' class", () => {
      navHamburger.click()
      expect(navHamburger.classList).toContain('clicked')
      navHamburger.click()
      expect(navHamburger.classList).not.toContain('clicked')
    })

    it("removes and adds navHamburger 'reset_animation' class", () => {
      navHamburger.click()
      expect(navHamburger.classList).not.toContain('reset_animation')
      navHamburger.click()
      expect(navHamburger.classList).toContain('reset_animation')
    })
  })

  describe("#menuToggle - navScreenCover click", () => { 
    it("sets menu open status to false", () => { 
      navMenu.setAttribute('data-nav-menu-open', 'true')
      navScreenCover.click()
      expect(navMenu.getAttribute('data-nav-menu-open')).toEqual('false')
      navScreenCover.click()
      expect(navMenu.getAttribute('data-nav-menu-open')).toEqual('false')
    })
  })
})