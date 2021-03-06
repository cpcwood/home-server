import { Application } from 'stimulus'
import headerScrollController from 'controllers/header_scroll_controller'

describe('header_scroll_controller', () => {
  let headerImage
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
        </div>
      `
      headerImage = document.querySelector('.header-image')
    })

    it('initial height', () => {
      window.pageYOffset = 0
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${imageHeight}px`)
    })

    it('scroll', () => {
      window.pageYOffset = 10
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${imageHeight - 10}px`)
      window.pageYOffset = 100
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${imageHeight - 100}px`)
    })

    it('scroll limit', () => {
      window.pageYOffset = imageHeight - headerHeight
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${headerHeight}px`)
      window.pageYOffset = imageHeight - headerHeight + 1
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${headerHeight}px`)
    })
  })

  describe('#scrollHeaderImage', () => {
    const imageHeight = 100
    const headerHeight = 40

    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller='header-scroll' data-action='turbolinks:before-cache@window->header-scroll#teardown scroll@window->header-scroll#scrollHeaderImage' data-header-scroll-image-height='${imageHeight}' data-header-scroll-header-height='${headerHeight}'>
          <div class='header-image' data-header-scroll-target='headerImage'></div>
        </div>
      `
      headerImage = document.querySelector('.header-image')
    })

    it('scroll - dynamic image and header height', () => {
      window.pageYOffset = 10
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${imageHeight - 10}px`)
      window.pageYOffset = 20
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${imageHeight - 20}px`)
    })
  })

  describe('#teardown', () => {
    const imageHeight = 100
    const headerHeight = 40

    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller='header-scroll' data-action='turbolinks:before-cache@window->header-scroll#teardown scroll@window->header-scroll#scrollHeaderImage' data-header-scroll-image-height='${imageHeight}' data-header-scroll-header-height='${headerHeight}'>
          <div class='header-image' data-header-scroll-target='headerImage'></div>
        </div>
      `
      headerImage = document.querySelector('.header-image')
    })

    it('turbolinks:before-cache', () => {
      window.pageYOffset = 10
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${imageHeight - 10}px`)
      window.dispatchEvent(new Event('turbolinks:before-cache'))
      expect(headerImage.style.height).toEqual(`${imageHeight}px`)
    })
  })
})
