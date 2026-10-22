/**
 * @jest-environment jsdom
 */

import { Application } from '@hotwired/stimulus'
import imageLoaderController from 'controllers/image_loader_controller'

jest.useFakeTimers()

// jsdom images report complete === true with no src, so model the browser
// states we care about explicitly: loading, loaded, and broken.
function defineImageState (image) {
  const state = { complete: false, naturalHeight: 0 }
  Object.defineProperty(image, 'complete', { configurable: true, get: () => state.complete })
  Object.defineProperty(image, 'naturalHeight', { configurable: true, get: () => state.naturalHeight })
  return state
}

describe('image_loader_controller', () => {
  beforeAll(() => {
    const application = Application.start()
    application.register('image-loader', imageLoaderController)
  })

  beforeEach(() => {
    jest.spyOn(window, 'requestAnimationFrame').mockImplementation(cb => cb())
  })

  afterEach(() => {
    window.requestAnimationFrame.mockRestore()
  })

  describe('images present', () => {
    let container
    let tileTwo
    let imageOne
    let imageTwo
    let stateOne
    let stateTwo

    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller="image-loader" data-image-loader-target="container" data-image-loader-tile-selector-value=".flex-image-tile">
          <div class="flex-image-tile">
            <img class="cover-image" data-action="load->image-loader#imageLoaded error->image-loader#imageError" data-image-loader-target="fade">
          </div>
          <div class="flex-image-tile">
            <img class="cover-image" data-action="load->image-loader#imageLoaded error->image-loader#imageError" data-image-loader-target="fade">
          </div>
        </div>
      `
      container = document.querySelector('[data-controller="image-loader"]')
      tileTwo = document.getElementsByClassName('flex-image-tile')[1]
      const images = document.getElementsByClassName('cover-image')
      imageOne = images[0]
      imageTwo = images[1]
      stateOne = defineImageState(imageOne)
      stateTwo = defineImageState(imageTwo)
    })

    function markLoaded (state) {
      state.complete = true
      state.naturalHeight = 1
    }

    function markBroken (state) {
      state.complete = true
      state.naturalHeight = 0
    }

    describe('#imageLoaded', () => {
      it('waits while an image is still loading', () => {
        markLoaded(stateOne)
        imageOne.dispatchEvent(new Event('load'))
        jest.advanceTimersByTime(1)
        expect(imageOne.classList).not.toContain('fade-in')
        expect(imageTwo.classList).not.toContain('fade-in')
      })

      it('fades in once every image has resolved', () => {
        markLoaded(stateOne)
        markLoaded(stateTwo)
        imageOne.dispatchEvent(new Event('load'))
        imageTwo.dispatchEvent(new Event('load'))
        jest.advanceTimersByTime(1)
        expect(imageOne.classList).toContain('fade-in')
        expect(imageTwo.classList).toContain('fade-in')
        expect(imageOne.style.transitionDelay).toBe('0s')
        expect(imageTwo.style.transitionDelay).toBe('0.1s')
      })
    })

    describe('#imageError', () => {
      it('flags the broken tile but still fades the grid in', () => {
        markLoaded(stateOne)
        markBroken(stateTwo)
        imageOne.dispatchEvent(new Event('load'))
        imageTwo.dispatchEvent(new Event('error'))
        jest.advanceTimersByTime(1)
        expect(tileTwo.classList).toContain('load-failed')
        expect(imageOne.classList).toContain('fade-in')
        expect(imageTwo.classList).toContain('fade-in')
      })
    })

    describe('load timeout', () => {
      it('flags the container and the straggling tile once the timeout elapses', () => {
        markLoaded(stateOne)
        imageOne.dispatchEvent(new Event('load'))
        jest.advanceTimersByTime(10000)
        expect(container.classList).toContain('load-timed-out')
        expect(tileTwo.classList).toContain('load-failed')
      })

      it('unflags a tile whose image arrives after the timeout', () => {
        markLoaded(stateOne)
        imageOne.dispatchEvent(new Event('load'))
        jest.advanceTimersByTime(10000)
        expect(tileTwo.classList).toContain('load-failed')
        markLoaded(stateTwo)
        imageTwo.dispatchEvent(new Event('load'))
        jest.advanceTimersByTime(1)
        expect(tileTwo.classList).not.toContain('load-failed')
      })

      it('does not flag the container when all images load first', () => {
        markLoaded(stateOne)
        markLoaded(stateTwo)
        imageOne.dispatchEvent(new Event('load'))
        imageTwo.dispatchEvent(new Event('load'))
        jest.advanceTimersByTime(10000)
        expect(container.classList).not.toContain('load-timed-out')
      })
    })
  })

  describe('no images', () => {
    let fadeTarget

    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller="image-loader" data-image-loader-target="container">
          <div id="fade-target" data-image-loader-target="fade">
            I still need fading in
          </div>
        </div>
      `
      fadeTarget = document.getElementById('fade-target')
    })

    describe('#initialize', () => {
      it('fade in still occurs', () => {
        jest.runOnlyPendingTimers()
        expect(fadeTarget.classList).toContain('fade-in')
      })
    })
  })
})
