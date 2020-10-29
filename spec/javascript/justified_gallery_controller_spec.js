import { Application } from 'stimulus'
import justifiedGalleryController from 'controllers/justified_gallery_controller'
import justifiedLayout from 'justified-layout'

require('./__mocks__/ResizeObserver')
jest.mock('justified-layout')

describe('touch_hover_tile_controller', () => {
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
    justifiedLayout.mockImplementation(() => {
      return {
        boxes: [
          { width: 20, height: 30 },
          { width: 40, height: 50 }
        ]
      }
    })
    document.body.innerHTML = `
      <div class='gallery-container' data-controller="justified-gallery" data-target="justified-gallery.container" data-justified-gallery-margin="${margin}" data-action='turbolinks:before-cache@window->justified-gallery#teardown'>
        <img class="gallery-item" data-action="load->justified-gallery#imageLoaded" data-target="justified-gallery.galleryItem" width=${galleryItemOneDimensions.width} height=${galleryItemOneDimensions.height}>
        <img class="gallery-item" data-action="load->justified-gallery#imageLoaded" data-target="justified-gallery.galleryItem" width=${galleryItemTwoDimensions.width} height=${galleryItemTwoDimensions.height}>
      </div>
    `
    const galleryItemTargets = document.getElementsByClassName('gallery-item')
    galleryItemTargetOne = galleryItemTargets[0]
    galleryItemTargetTwo = galleryItemTargets[1]
  })

  afterEach(() => {
    jest.clearAllMocks()
  })

  describe('#imageLoaded', () => {
    describe('not all images loaded', () => {
      it('controller waiting', () => {
        galleryItemTargetOne.dispatchEvent(new Event('load'))
        expect(galleryItemTargetOne.classList).not.toContain('fade-in')
        expect(galleryItemTargetTwo.classList).not.toContain('fade-in')
        expect(justifiedLayout).not.toHaveBeenCalled()
      })
    })

    describe('all images loaded', () => {
      it('fade in', () => {
        galleryItemTargetOne.dispatchEvent(new Event('load'))
        galleryItemTargetTwo.dispatchEvent(new Event('load'))
        expect(galleryItemTargetOne.classList).toContain('fade-in')
        expect(galleryItemTargetTwo.classList).toContain('fade-in')
      })

      it('images justified', () => {
        const containerWidth = 15
        const galleryContainer = document.querySelector('.gallery-container')
        jest
          .spyOn(galleryContainer, 'clientWidth', 'get')
          .mockImplementation(() => containerWidth)
        galleryItemTargetOne.dispatchEvent(new Event('load'))
        galleryItemTargetTwo.dispatchEvent(new Event('load'))

        expect(justifiedLayout).toHaveBeenCalledWith([
          galleryItemOneDimensions,
          galleryItemTwoDimensions
        ], {
          boxSpacing: {
            horizontal: margin,
            vertical: 0
          },
          containerWidth: containerWidth
        })
        expect(galleryItemTargetOne.width).toEqual(20)
        expect(galleryItemTargetOne.height).toEqual(30)
        expect(galleryItemTargetTwo.width).toEqual(40)
        expect(galleryItemTargetTwo.height).toEqual(50)
      })
    })
  })

  describe('#teardown', () => {
    it('reset to cache safe state', () => {
      galleryItemTargetOne.dispatchEvent(new Event('load'))
      galleryItemTargetTwo.dispatchEvent(new Event('load'))
      window.dispatchEvent(new Event('turbolinks:before-cache'))
      expect(galleryItemTargetOne.classList).not.toContain('fade-in')
      expect(galleryItemTargetTwo.classList).not.toContain('fade-in')
      expect(galleryItemTargetOne.style.transitionDelay).toBe('')
      expect(galleryItemTargetTwo.style.transitionDelay).toBe('')
    })
  })
})
