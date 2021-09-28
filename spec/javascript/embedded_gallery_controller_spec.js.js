/**
 * @jest-environment jsdom
 */

import { Application } from 'stimulus'
import embeddedGalleryController from 'controllers/embedded_gallery_controller'

jest.useFakeTimers()

describe('embedded_gallery_controller', () => {
  let startPosition = 0
  let nextButton
  let prevButton
  let image1
  let image2
  let image3

  const assignHTML = () => {
    document.body.innerHTML = `
      <div id="container" data-controller="embedded-gallery" data-embedded-gallery-position="${startPosition}" data-action='turbolinks:before-cache@window->embedded-gallery#teardown'>
        <img id='image1' data-embedded-gallery-target="image">
        <img id='image2' data-embedded-gallery-target="image">
        <img id='image3' data-embedded-gallery-target="image">
        <button id='prev-button' data-action="click->embedded-gallery#prev" data-embedded-gallery-target="navButton">‹</button>
        <button id='next-button' data-action="click->embedded-gallery#next" data-embedded-gallery-target="navButton">›</button>
      </div>
    `
    nextButton = document.querySelector('#next-button')
    prevButton = document.querySelector('#prev-button')
    image1 = document.querySelector('#image1')
    image2 = document.querySelector('#image2')
    image3 = document.querySelector('#image3')
  }

  beforeAll(() => {
    const application = Application.start()
    application.register('embedded-gallery', embeddedGalleryController)
  })

  afterEach(() => {
    startPosition = 0
  })

  describe('#connect', () => {
    describe('0 start position', () => {
      beforeEach(() => {
        assignHTML()
      })

      it('image styles', () => {
        expect(image1.style.opacity).toEqual('1')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        expect(image1.style.zIndex).toEqual('1')
        expect(image2.style.zIndex).toEqual('')
        expect(image3.style.zIndex).toEqual('')
      })

      it('navButton styles', () => {
        expect(nextButton.style.display).toEqual('flex')
        expect(prevButton.style.display).toEqual('flex')
      })
    })

    describe('1 start position', () => {
      beforeEach(() => {
        startPosition = 1
        assignHTML()
      })

      it('image styles', () => {
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('1')
        expect(image3.style.opacity).toEqual('0')
        expect(image1.style.zIndex).toEqual('')
        expect(image2.style.zIndex).toEqual('1')
        expect(image3.style.zIndex).toEqual('')
      })
    })

    describe('-1 start position', () => {
      beforeEach(() => {
        startPosition = -1
        assignHTML()
      })

      it('image styles', () => {
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('1')
        expect(image1.style.zIndex).toEqual('')
        expect(image2.style.zIndex).toEqual('')
        expect(image3.style.zIndex).toEqual('1')
      })
    })

    describe('invalid integer start position', () => {
      beforeEach(() => {
        startPosition = -10
        assignHTML()
      })

      it('image styles', () => {
        expect(image1.style.opacity).toEqual('1')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        expect(image1.style.zIndex).toEqual('1')
        expect(image2.style.zIndex).toEqual('')
        expect(image3.style.zIndex).toEqual('')
      })
    })

    describe('invalid integer format position', () => {
      beforeEach(() => {
        startPosition = 'not an integer'
        assignHTML()
      })

      it('image styles', () => {
        expect(image1.style.opacity).toEqual('1')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        expect(image1.style.zIndex).toEqual('1')
        expect(image2.style.zIndex).toEqual('')
        expect(image3.style.zIndex).toEqual('')
      })
    })
  })

  describe('#next', () => {
    describe('0 position', () => {
      beforeEach(() => {
        startPosition = 0
        assignHTML()
      })

      it('image styles', () => {
        nextButton.dispatchEvent(new Event('click'))
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        jest.runOnlyPendingTimers()
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('1')
        expect(image3.style.opacity).toEqual('0')
        expect(image1.style.zIndex).toEqual('')
        expect(image2.style.zIndex).toEqual('1')
        expect(image3.style.zIndex).toEqual('')
      })
    })

    describe('1 position', () => {
      beforeEach(() => {
        startPosition = 1
        assignHTML()
      })

      it('image styles', () => {
        nextButton.dispatchEvent(new Event('click'))
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        jest.runOnlyPendingTimers()
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('1')
        expect(image1.style.zIndex).toEqual('')
        expect(image2.style.zIndex).toEqual('')
        expect(image3.style.zIndex).toEqual('1')
      })
    })

    describe('2 position', () => {
      beforeEach(() => {
        startPosition = 2
        assignHTML()
      })

      it('image styles', () => {
        nextButton.dispatchEvent(new Event('click'))
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        jest.runOnlyPendingTimers()
        expect(image1.style.opacity).toEqual('1')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        expect(image1.style.zIndex).toEqual('1')
        expect(image2.style.zIndex).toEqual('')
        expect(image3.style.zIndex).toEqual('')
      })
    })

    describe('double click before initial timer complete', () => {
      beforeEach(() => {
        startPosition = 0
        assignHTML()
      })

      it('image styles', () => {
        nextButton.dispatchEvent(new Event('click'))
        nextButton.dispatchEvent(new Event('click'))
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        jest.runOnlyPendingTimers()
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('1')
        expect(image1.style.zIndex).toEqual('')
        expect(image2.style.zIndex).toEqual('')
        expect(image3.style.zIndex).toEqual('1')
      })
    })

    describe('double click before next image fade in timer complete', () => {
      beforeEach(() => {
        startPosition = 0
        assignHTML()
      })

      it('image styles', () => {
        nextButton.dispatchEvent(new Event('click'))
        jest.runOnlyPendingTimers()
        nextButton.dispatchEvent(new Event('click'))
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('1')
        expect(image1.style.zIndex).toEqual('')
        expect(image2.style.zIndex).toEqual('')
        expect(image3.style.zIndex).toEqual('1')
      })
    })
  })

  describe('#prev', () => {
    describe('0 position', () => {
      beforeEach(() => {
        startPosition = 0
        assignHTML()
      })

      it('image styles', () => {
        prevButton.dispatchEvent(new Event('click'))
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        jest.runOnlyPendingTimers()
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('1')
        expect(image1.style.zIndex).toEqual('')
        expect(image2.style.zIndex).toEqual('')
        expect(image3.style.zIndex).toEqual('1')
      })
    })

    describe('1 position', () => {
      beforeEach(() => {
        startPosition = 1
        assignHTML()
      })

      it('image styles', () => {
        prevButton.dispatchEvent(new Event('click'))
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        jest.runOnlyPendingTimers()
        expect(image1.style.opacity).toEqual('1')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        expect(image1.style.zIndex).toEqual('1')
        expect(image2.style.zIndex).toEqual('')
        expect(image3.style.zIndex).toEqual('')
      })
    })

    describe('2 position', () => {
      beforeEach(() => {
        startPosition = 2
        assignHTML()
      })

      it('image styles', () => {
        prevButton.dispatchEvent(new Event('click'))
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        jest.runOnlyPendingTimers()
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('1')
        expect(image3.style.opacity).toEqual('0')
        expect(image1.style.zIndex).toEqual('')
        expect(image2.style.zIndex).toEqual('1')
        expect(image3.style.zIndex).toEqual('')
      })
    })

    describe('double click before initial timer complete', () => {
      beforeEach(() => {
        startPosition = 0
        assignHTML()
      })

      it('image styles', () => {
        prevButton.dispatchEvent(new Event('click'))
        prevButton.dispatchEvent(new Event('click'))
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        jest.runOnlyPendingTimers()
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('1')
        expect(image3.style.opacity).toEqual('0')
        expect(image1.style.zIndex).toEqual('')
        expect(image2.style.zIndex).toEqual('1')
        expect(image3.style.zIndex).toEqual('')
      })
    })

    describe('double click before next image fade in timer complete', () => {
      beforeEach(() => {
        startPosition = 0
        assignHTML()
      })

      it('image styles', () => {
        prevButton.dispatchEvent(new Event('click'))
        jest.runOnlyPendingTimers()
        prevButton.dispatchEvent(new Event('click'))
        expect(image1.style.opacity).toEqual('0')
        expect(image2.style.opacity).toEqual('1')
        expect(image3.style.opacity).toEqual('0')
        expect(image1.style.zIndex).toEqual('')
        expect(image2.style.zIndex).toEqual('1')
        expect(image3.style.zIndex).toEqual('')
      })
    })
  })

  describe('#teardown', () => {
    describe('reset position', () => {
      beforeEach(() => {
        startPosition = 2
        assignHTML()
      })

      it('image styles', () => {
        window.dispatchEvent(new Event('turbolinks:before-cache'))
        expect(image1.style.opacity).toEqual('1')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        expect(image1.style.zIndex).toEqual('1')
        expect(image2.style.zIndex).toEqual('')
        expect(image3.style.zIndex).toEqual('')
      })
    })
  })

  describe('one image', () => {
    beforeEach(() => {
      document.body.innerHTML = `
        <div id="container" data-controller="embedded-gallery" data-embedded-gallery-position="${startPosition}" data-action='turbolinks:before-cache@window->embedded-gallery#teardown'>
          <img id='image1' data-embedded-gallery-target="image">
          <button id='prev-button' data-action="click->embedded-gallery#prev" data-embedded-gallery-target="navButton">‹</button>
          <button id='next-button' data-action="click->embedded-gallery#next" data-embedded-gallery-target="navButton">›</button>
        </div>
      `
      nextButton = document.querySelector('#next-button')
      prevButton = document.querySelector('#prev-button')
    })

    it('navButton styles', () => {
      expect(nextButton.style.display).toEqual('')
      expect(prevButton.style.display).toEqual('')
    })
  })

  describe('#teardown', () => {
    describe('reset position', () => {
      beforeEach(() => {
        startPosition = 2
        assignHTML()
      })

      it('image styles', () => {
        window.dispatchEvent(new Event('turbolinks:before-cache'))
        expect(image1.style.opacity).toEqual('1')
        expect(image2.style.opacity).toEqual('0')
        expect(image3.style.opacity).toEqual('0')
        expect(image1.style.zIndex).toEqual('1')
        expect(image2.style.zIndex).toEqual('')
        expect(image3.style.zIndex).toEqual('')
      })

      it('navButton styles', () => {
        window.dispatchEvent(new Event('turbolinks:before-cache'))
        expect(nextButton.style.display).toEqual('none')
        expect(prevButton.style.display).toEqual('none')
      })
    })
  })
})
