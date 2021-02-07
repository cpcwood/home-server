import { Application } from 'stimulus'
import headerScrollController from 'controllers/header_scroll_controller'

describe('header_scroll_controller', () => {
  let headerImage
  let contentContainer
  let application

  beforeAll(() => {
    application = Application.start()
    application.register('header-scroll', headerScrollController)
  })

  beforeEach(() => {
    jest.spyOn(window, 'requestAnimationFrame').mockImplementation(cb => cb());
  });
  
  afterEach(() => {
    window.requestAnimationFrame.mockRestore();
  });

  describe('#scrollHeaderImage', () => {
    const imageHeight = 300
    const headerHeight = 60

    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller='header-scroll' data-action='turbolinks:before-cache@window->header-scroll#teardown' data-header-scroll-image-height='${imageHeight}' data-header-scroll-header-height='${headerHeight}'>
          <div class='header-image' data-header-scroll-target='headerImage'></div>
          <div class='content-container' data-action='scroll->header-scroll#scrollHeaderImage' data-header-scroll-target='contentContainer'></div>
        </div>
      `
      headerImage = document.querySelector('.header-image')
      contentContainer = document.querySelector('.content-container')
    })

    it('initial height', () => {
      contentContainer.scrollTop = 0
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${imageHeight}px`)
    })

    it('scroll', () => {
      contentContainer.scrollTop = 10
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${imageHeight - 10}px`)
      contentContainer.scrollTop = 100
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${imageHeight - 100}px`)
    })

    it('scroll limit', () => {
      contentContainer.scrollTop = imageHeight - headerHeight
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${headerHeight}px`)
      contentContainer.scrollTop = imageHeight - headerHeight + 1
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${headerHeight}px`)
    })

    it('z-index while scrolling', () => {
      contentContainer.scrollTop = 0
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.zIndex).toEqual('-1')
      contentContainer.scrollTop = imageHeight - headerHeight - 1
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.zIndex).toEqual('-1')
    })

    it('z-index at limit', () => {
      contentContainer.scrollTop = imageHeight - headerHeight
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.zIndex).toEqual('2')
    })
  })

  describe('#scrollHeaderImage', () => {
    const imageHeight = 100
    const headerHeight = 40

    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller='header-scroll' data-action='turbolinks:before-cache@window->headerScroll#disconnect' data-header-scroll-image-height='${imageHeight}' data-header-scroll-header-height='${headerHeight}'>
          <div class='header-image' data-header-scroll-target='headerImage'></div>
          <div class='content-container' data-action='scroll->header-scroll#scrollHeaderImage' data-header-scroll-target='contentContainer'></div>
        </div>
      `
      headerImage = document.querySelector('.header-image')
      contentContainer = document.querySelector('.content-container')
    })

    it('scroll - dynamic image and header height', () => {
      contentContainer.scrollTop = 10
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${imageHeight - 10}px`)
      contentContainer.scrollTop = 20
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${imageHeight - 20}px`)
    })
  })

  describe('#teardown', () => {
    const imageHeight = 100
    const headerHeight = 40

    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller='header-scroll' data-action='turbolinks:before-cache@window->header-scroll#teardown' data-header-scroll-image-height='${imageHeight}' data-header-scroll-header-height='${headerHeight}'>
          <div class='header-image' data-header-scroll-target='headerImage' style='height: ${imageHeight}px'></div>
          <div class='content-container' data-action='scroll->header-scroll#scrollHeaderImage' data-header-scroll-target='contentContainer'></div>
        </div>
      `
      contentContainer = document.querySelector('.content-container')
      headerImage = document.querySelector('.header-image')
    })

    it('turbolinks:before-cache', () => {
      contentContainer.scrollTop = 10
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual(`${imageHeight - 10}px`)
      window.dispatchEvent(new Event('turbolinks:before-cache'))
      expect(headerImage.style.height).toEqual(`${imageHeight}px`)
      expect(headerImage.style.zIndex).toEqual('-1')
    })
  })
})
