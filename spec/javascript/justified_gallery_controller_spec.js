import { Application } from 'stimulus'
import justifiedGalleryController from 'controllers/justified_gallery_controller'

describe('touch_hover_tile_controller', () => {
  let galleryItemTargetOne
  let galleryItemTargetTwo

  beforeAll(() => {
    const application = Application.start()
    application.register('justified-gallery', justifiedGalleryController)
  })

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller="justified-gallery" data-target="image-loader.container">
        <img width=100 height=150 class="gallery-item" data-action="load->justified-gallery#imageLoaded" data-target="justified-gallery.galleryItem">
        <img width=200 height=250 class="gallery-item" data-action="load->justified-gallery#imageLoaded" data-target="justified-gallery.galleryItem">
      </div>
    `
    const galleryItemTargets = document.getElementsByClassName('gallery-item')
    galleryItemTargetOne = galleryItemTargets[0]
    galleryItemTargetTwo = galleryItemTargets[1]
  })

  describe('fade in', () => {
    it('not all images loaded', () => {
      galleryItemTargetOne.dispatchEvent(new Event('load'))
      expect(galleryItemTargetOne.classList).not.toContain('fade-in')
      expect(galleryItemTargetTwo.classList).not.toContain('fade-in')
    })

    it('all images loaded', () => {
      galleryItemTargetOne.dispatchEvent(new Event('load'))
      galleryItemTargetTwo.dispatchEvent(new Event('load'))
      expect(galleryItemTargetOne.classList).toContain('fade-in')
      expect(galleryItemTargetTwo.classList).toContain('fade-in')
    })
  })

  describe('justify images', () => {
    it('not all images loaded', () => {
      galleryItemTargetOne.dispatchEvent(new Event('load'))
      // expect module not to be hit
    })

    it('all images loaded', () => {
      galleryItemTargetOne.dispatchEvent(new Event('load'))
      galleryItemTargetTwo.dispatchEvent(new Event('load'))
      // expect module to be hit
      // expect width and height to have change to mocked return values
    })
  })
})
