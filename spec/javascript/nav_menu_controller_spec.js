/**
 * @jest-environment jsdom
 */

import { Application } from 'stimulus'
import navMenuController from 'controllers/nav_menu_controller'
const fs = require('fs')

describe('nav_menu_controller', () => {
  let navHamburger
  let navSidebar
  let navScreenCover
  let navMenu
  let applicationHTML

  beforeAll(done => {
    const application = Application.start()
    application.register('nav-menu', navMenuController)
    fs.readFile('app/views/partials/_navigation.html.erb', 'utf8', (err, data) => {
      if (err) throw new Error(err)
      applicationHTML = data
      done()
    })
  })

  beforeEach(() => {
    document.body.innerHTML = applicationHTML
    navMenu = document.querySelector('.nav-menu')
    navHamburger = document.querySelector('.hamburger-container')
    navSidebar = document.querySelector('.nav-sidebar')
    navScreenCover = document.querySelector('.nav-screen-cover')
  })

  describe('#menuToggle - navHamburger click', () => {
    it('toggles menu open status', () => {
      expect(navMenu.getAttribute('data-nav-menu-open')).toEqual('false')
      navHamburger.click()
      expect(navMenu.getAttribute('data-nav-menu-open')).toEqual('true')
      navHamburger.click()
      expect(navMenu.getAttribute('data-nav-menu-open')).toEqual('false')
    })

    it("adds and removes navSidebar 'sidebar-open' class", () => {
      navHamburger.click()
      expect(navSidebar.classList).toContain('sidebar-open')
      navHamburger.click()
      expect(navSidebar.classList).not.toContain('sidebar-open')
    })

    it("adds and removes navHamburger 'clicked' class", () => {
      navHamburger.click()
      expect(navHamburger.classList).toContain('clicked')
      navHamburger.click()
      expect(navHamburger.classList).not.toContain('clicked')
    })

    it("removes and adds navHamburger 'reset-animation' class", () => {
      navHamburger.click()
      expect(navHamburger.classList).not.toContain('reset-animation')
      navHamburger.click()
      expect(navHamburger.classList).toContain('reset-animation')
    })
  })

  describe('#menuToggle - navScreenCover click', () => {
    it('sets menu open status to false', () => {
      navMenu.setAttribute('data-nav-menu-open', 'true')
      navScreenCover.click()
      expect(navMenu.getAttribute('data-nav-menu-open')).toEqual('false')
      navScreenCover.click()
      expect(navMenu.getAttribute('data-nav-menu-open')).toEqual('false')
    })
  })
})
