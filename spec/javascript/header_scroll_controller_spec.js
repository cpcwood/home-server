/**
 * @jest-environment jsdom
 */

import { Application } from 'stimulus'
import headerScrollController from 'controllers/header_scroll_controller'

describe('header_scroll_controller', () => {
  let headerImage
  let navImage
  let application

  beforeAll(() => {
    application = Application.start()
    application.register('header-scroll', headerScrollController)
  })

  beforeEach(() => {
    jest.spyOn(window, 'requestAnimationFrame').mockImplementation(cb => cb())
  })

  afterEach(() => {
    window.requestAnimationFrame.mockRestore()
  })

  describe('#scrollHeaderImage', () => {
    const imageHeight = 300
    const headerHeight = 60

    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller='header-scroll' data-action='turbolinks:before-cache@window->header-scroll#teardown scroll@window->header-scroll#scrollHeaderImage' data-header-scroll-image-height='${imageHeight}' data-header-scroll-header-height='${headerHeight}'>
          <div class='header-image' data-header-scroll-target='headerImage'></div>
          <div class='nav-image' data-header-scroll-target='navImage'></div>
        </div>
      `
      headerImage = document.querySelector('.header-image')
      navImage = document.querySelector('.nav-image')
    })

    it('initial height', () => {
      window.pageYOffset = 0
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.bottom).toEqual('0px')
      expect(navImage.style.top).toEqual('0px')
    })

    it('scroll', () => {
      let scrollTop = 10
      window.pageYOffset = scrollTop
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.bottom).toEqual(`${-scrollTop / 3}px`)
      expect(navImage.style.top).toEqual(`${-(scrollTop - scrollTop / 3)}px`)

      scrollTop = 100
      window.pageYOffset = scrollTop
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.bottom).toEqual(`${-scrollTop / 3}px`)
      expect(navImage.style.top).toEqual(`${-(scrollTop - scrollTop / 3)}px`)
    })

    it('scroll limit', () => {
      const scrollLimit = imageHeight - headerHeight
      window.pageYOffset = scrollLimit
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.bottom).toEqual(`${-scrollLimit / 3}px`)
      expect(navImage.style.top).toEqual(`${-(scrollLimit - scrollLimit / 3)}px`)

      window.pageYOffset = scrollLimit + 1
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.bottom).toEqual(`${-scrollLimit / 3}px`)
      expect(navImage.style.top).toEqual(`${-(scrollLimit - scrollLimit / 3)}px`)
    })
  })

  describe('#teardown', () => {
    const imageHeight = 100
    const headerHeight = 40

    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller='header-scroll' data-action='turbolinks:before-cache@window->header-scroll#teardown scroll@window->header-scroll#scrollHeaderImage' data-header-scroll-image-height='${imageHeight}' data-header-scroll-header-height='${headerHeight}'>
          <div class='header-image' data-header-scroll-target='headerImage'></div>
          <div class='nav-image' data-header-scroll-target='navImage'></div>
        </div>
      `
      headerImage = document.querySelector('.header-image')
      navImage = document.querySelector('.nav-image')
    })

    it('turbolinks:before-cache', () => {
      const scrollTop = 10
      window.pageYOffset = scrollTop
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.bottom).toEqual(`${-scrollTop / 3}px`)
      expect(navImage.style.top).toEqual(`${-(scrollTop - scrollTop / 3)}px`)

      window.dispatchEvent(new Event('turbolinks:before-cache'))
      expect(headerImage.style.bottom).toEqual('0px')
      expect(navImage.style.top).toEqual('0px')
    })
  })
})
