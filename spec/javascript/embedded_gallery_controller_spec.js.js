import { Application } from 'stimulus'
import embeddedGalleryController from 'controllers/embedded_gallery_controller'

describe('embedded_gallery_controller', () => {
  let startPosition = 0
  let nextButton
  let prevButton
  let image1
  let image2
  let image3

  function assignHTML () {
    document.body.innerHTML = `
      <div id="container" data-controller="embedded-gallery" data-embedded-gallery-position="${startPosition}" data-action='turbolinks:before-cache@window->embedded-gallery#teardown'>
        <img id='image1' data-target="embedded-gallery.image">
        <img id='image2' data-target="embedded-gallery.image">
        <img id='image3' data-target="embedded-gallery.image">
        <button id='prev-button' data-action="click->embedded-gallery#prev">‹</button>
        <button id='next-button' data-action="click->embedded-gallery#next">›</button>
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
        expect(image1.style.display).toEqual('block')
        expect(image2.style.display).toEqual('none')
        expect(image3.style.display).toEqual('none')
      })
    })

    describe('1 start position', () => {
      beforeEach(() => {
        startPosition = 1
        assignHTML()
      })

      it('image styles', () => {
        expect(image1.style.display).toEqual('none')
        expect(image2.style.display).toEqual('block')
        expect(image3.style.display).toEqual('none')
      })
    })

    describe('-1 start position', () => {
      beforeEach(() => {
        startPosition = -1
        assignHTML()
      })

      it('image styles', () => {
        expect(image1.style.display).toEqual('none')
        expect(image2.style.display).toEqual('none')
        expect(image3.style.display).toEqual('block')
      })
    })

    describe('invalid integer start position', () => {
      beforeEach(() => {
        startPosition = -10
        assignHTML()
      })

      it('image styles', () => {
        expect(image1.style.display).toEqual('block')
        expect(image2.style.display).toEqual('none')
        expect(image3.style.display).toEqual('none')
      })
    })

    describe('invalid integer format position', () => {
      beforeEach(() => {
        startPosition = 'not an integer'
        assignHTML()
      })

      it('image styles', () => {
        expect(image1.style.display).toEqual('block')
        expect(image2.style.display).toEqual('none')
        expect(image3.style.display).toEqual('none')
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
        expect(image1.style.display).toEqual('none')
        expect(image2.style.display).toEqual('block')
        expect(image3.style.display).toEqual('none')
      })
    })

    describe('1 position', () => {
      beforeEach(() => {
        startPosition = 1
        assignHTML()
      })

      it('image styles', () => {
        nextButton.dispatchEvent(new Event('click'))
        expect(image1.style.display).toEqual('none')
        expect(image2.style.display).toEqual('none')
        expect(image3.style.display).toEqual('block')
      })
    })

    describe('2 position', () => {
      beforeEach(() => {
        startPosition = 2
        assignHTML()
      })

      it('image styles', () => {
        nextButton.dispatchEvent(new Event('click'))
        expect(image1.style.display).toEqual('block')
        expect(image2.style.display).toEqual('none')
        expect(image3.style.display).toEqual('none')
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
        expect(image1.style.display).toEqual('none')
        expect(image2.style.display).toEqual('none')
        expect(image3.style.display).toEqual('block')
      })
    })

    describe('1 position', () => {
      beforeEach(() => {
        startPosition = 1
        assignHTML()
      })

      it('image styles', () => {
        prevButton.dispatchEvent(new Event('click'))
        expect(image1.style.display).toEqual('block')
        expect(image2.style.display).toEqual('none')
        expect(image3.style.display).toEqual('none')
      })
    })

    describe('2 position', () => {
      beforeEach(() => {
        startPosition = 2
        assignHTML()
      })

      it('image styles', () => {
        prevButton.dispatchEvent(new Event('click'))
        expect(image1.style.display).toEqual('none')
        expect(image2.style.display).toEqual('block')
        expect(image3.style.display).toEqual('none')
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
        expect(image1.style.display).toEqual('block')
        expect(image2.style.display).toEqual('none')
        expect(image3.style.display).toEqual('none')
      })
    })
  })
})
