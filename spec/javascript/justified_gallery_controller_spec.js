/**
 * @jest-environment jsdom
 */

import { Application } from 'stimulus'
import justifiedGalleryController from 'controllers/justified_gallery_controller'
import justifiedLayout from 'justified-layout'

require('./__mocks__/ResizeObserver')
jest.mock('justified-layout')
jest.useFakeTimers()

describe('justified_gallery_controller', () => {
  let galleryContainer
  let galleryItemTargetOne
  const galleryItemOneDimensions = {
    width: 100,
    height: 150
  }
  let galleryItemTargetTwo
  const galleryItemTwoDimensions = {
    width: 200,
    height: 250
  }
  const margin = 10

  beforeAll(() => {
    const application = Application.start()
    application.register('justified-gallery', justifiedGalleryController)
  })

  beforeEach(() => {
    jest.spyOn(window, 'requestAnimationFrame').mockImplementation(cb => cb())
    justifiedLayout.mockImplementation(() => {
      return {
        boxes: [
          { width: 20, height: 30 },
          { width: 40, height: 50 }
        ]
      }
    })
    document.body.innerHTML = `
      <div class='gallery-container' data-controller="justified-gallery" data-justified-gallery-target="container" data-justified-gallery-margin="${margin}">
        <img class="gallery-item" data-action="load->justified-gallery#imageLoaded" data-justified-gallery-target="galleryItem" width=${galleryItemOneDimensions.width} height=${galleryItemOneDimensions.height}>
        <img class="gallery-item" data-action="load->justified-gallery#imageLoaded" data-justified-gallery-target="galleryItem" width=${galleryItemTwoDimensions.width} height=${galleryItemTwoDimensions.height}>
      </div>
    `
    galleryContainer = document.querySelector('.gallery-container')
    const galleryItemTargets = document.getElementsByClassName('gallery-item')
    galleryItemTargetOne = galleryItemTargets[0]
    galleryItemTargetTwo = galleryItemTargets[1]
    galleryItemTargetOne.addEventListener('load', () => {
      jest.spyOn(galleryItemTargetOne, 'naturalHeight', 'get').mockReturnValue(1)
    })
    galleryItemTargetTwo.addEventListener('load', () => {
      jest.spyOn(galleryItemTargetTwo, 'naturalHeight', 'get').mockReturnValue(1)
    })
  })

  afterEach(() => {
    jest.clearAllMocks()
    window.requestAnimationFrame.mockRestore()
  })

  describe('#imageLoaded', () => {
    describe('not all images loaded', () => {
      it('controller waiting', () => {
        galleryItemTargetOne.dispatchEvent(new Event('load'))
        jest.runOnlyPendingTimers()
        expect(galleryItemTargetOne.classList).not.toContain('fade-in')
        expect(galleryItemTargetTwo.classList).not.toContain('fade-in')
        expect(justifiedLayout).not.toHaveBeenCalled()
      })
    })

    describe('all images loaded', () => {
      it('fade in', () => {
        galleryItemTargetOne.dispatchEvent(new Event('load'))
        galleryItemTargetTwo.dispatchEvent(new Event('load'))
        jest.runOnlyPendingTimers()
        expect(galleryItemTargetOne.classList).toContain('fade-in')
        expect(galleryItemTargetTwo.classList).toContain('fade-in')
      })

      it('galleryRendered Event', () => {
        let eventTriggered = false
        galleryContainer.addEventListener('galleryRendered', () => {
          eventTriggered = true
        })
        galleryItemTargetOne.dispatchEvent(new Event('load'))
        galleryItemTargetTwo.dispatchEvent(new Event('load'))
        jest.runOnlyPendingTimers()
        expect(eventTriggered).toBe(true)
      })

      it('images justified', () => {
        const containerWidth = 15
        const galleryContainer = document.querySelector('.gallery-container')
        jest
          .spyOn(galleryContainer, 'clientWidth', 'get')
          .mockImplementation(() => containerWidth)
        galleryItemTargetOne.dispatchEvent(new Event('load'))
        galleryItemTargetTwo.dispatchEvent(new Event('load'))
        jest.runOnlyPendingTimers()

        expect(justifiedLayout).toHaveBeenCalledWith([
          galleryItemOneDimensions,
          galleryItemTwoDimensions
        ], {
          boxSpacing: {
            horizontal: margin,
            vertical: 0
          },
          containerWidth: containerWidth,
          targetRowHeight: 295
        })
        expect(galleryItemTargetOne.width).toEqual(20)
        expect(galleryItemTargetOne.height).toEqual(30)
        expect(galleryItemTargetTwo.width).toEqual(40)
        expect(galleryItemTargetTwo.height).toEqual(50)
      })
    })
  })
})
