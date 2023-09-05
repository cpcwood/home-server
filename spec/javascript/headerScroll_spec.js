/**
 * @jest-environment jsdom
 */

import headerScroll from 'listeners/headerScroll'

describe('header_scroll_controller', () => {
  let headerImage
  let navImage

  beforeEach(() => {
    jest.spyOn(window, 'requestAnimationFrame').mockImplementation((cb) => cb())
    window.addEventListener('scroll', headerScroll, { passive: true })
  })

  afterEach(() => {
    window.requestAnimationFrame.mockRestore()
    window.removeEventListener('scroll', headerScroll)
  })

  describe('#scrollHeaderImage', () => {
    const imageHeight = 300
    const headerHeight = 60

    beforeEach(() => {
      document.body.innerHTML = `
        <div id='header-scroll' data-header-scroll-image-height='${imageHeight}' data-header-scroll-header-height='${headerHeight}'>
          <div id='header-image'></div>
          <div id='nav-image'></div>
        </div>
      `
      headerImage = document.querySelector('#header-image')
      navImage = document.querySelector('#nav-image')
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
      expect(headerImage.style.bottom).toEqual(`${-scrollTop / 3.5}px`)
      expect(navImage.style.top).toEqual(`${-(scrollTop - scrollTop / 3.5)}px`)

      scrollTop = 100
      window.pageYOffset = scrollTop
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.bottom).toEqual(`${-scrollTop / 3.5}px`)
      expect(navImage.style.top).toEqual(`${-(scrollTop - scrollTop / 3.5)}px`)
    })

    it('scroll limit', () => {
      const scrollLimit = imageHeight - headerHeight
      window.pageYOffset = scrollLimit
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.bottom).toEqual(`${-scrollLimit / 3.5}px`)
      expect(navImage.style.top).toEqual(`${-(scrollLimit - scrollLimit / 3.5)}px`)

      window.pageYOffset = scrollLimit + 1
      window.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.bottom).toEqual(`${-scrollLimit / 3.5}px`)
      expect(navImage.style.top).toEqual(`${-(scrollLimit - scrollLimit / 3.5)}px`)
    })
  })
})
