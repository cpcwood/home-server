/**
 * @jest-environment jsdom
 */

import { Application } from '@hotwired/stimulus'
import imageLoaderController from 'controllers/image_loader_controller'

jest.useFakeTimers()

describe('image_loader_controller', () => {
  let fadeTargetOne
  let fadeTargetTwo

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
    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller="image-loader" data-image-loader-target="container">
          <img class="fade-target" data-action="load->image-loader#imageLoaded" data-image-loader-target="fade">
          <img class="fade-target" data-action="load->image-loader#imageLoaded" data-image-loader-target="fade">
        </div>
      `
      const fadeTargets = document.getElementsByClassName('fade-target')
      fadeTargetOne = fadeTargets[0]
      fadeTargetTwo = fadeTargets[1]
      fadeTargetOne.addEventListener('load', () => {
        jest.spyOn(fadeTargetOne, 'naturalHeight', 'get').mockReturnValue(1)
      })
      fadeTargetTwo.addEventListener('load', () => {
        jest.spyOn(fadeTargetTwo, 'naturalHeight', 'get').mockReturnValue(1)
      })
    })

    describe('#imageLoaded', () => {
      it('not all images loaded', () => {
        fadeTargetOne.dispatchEvent(new Event('load'))
        jest.runOnlyPendingTimers()
        expect(fadeTargetOne.classList).not.toContain('fade-in')
        expect(fadeTargetTwo.classList).not.toContain('fade-in')
      })

      it('all images loaded', () => {
        fadeTargetOne.dispatchEvent(new Event('load'))
        fadeTargetTwo.dispatchEvent(new Event('load'))
        jest.runOnlyPendingTimers()
        expect(fadeTargetOne.classList).toContain('fade-in')
        expect(fadeTargetTwo.classList).toContain('fade-in')
        expect(fadeTargetOne.style.transitionDelay).toBe('0s')
        expect(fadeTargetTwo.style.transitionDelay).toBe('0.1s')
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
