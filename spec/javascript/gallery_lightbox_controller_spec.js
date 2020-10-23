import { Application } from 'stimulus'
import galleryLightboxController from 'controllers/gallery_lightbox_controller'
import SimpleLightbox from 'simplelightbox'

jest.mock('simplelightbox', () => {
  return jest.fn().mockImplementation(() => {
  })
})

describe('touch_hover_tile_controller', () => {
  const galleryContainerItemSelector = '.gallery-container a'
  const pathToGalleryItem = 'path-to-full-image.jpg'
  const galleryItemDescription = 'gallery item description'

  beforeAll(() => {
    const application = Application.start()
    application.register('gallery-lightbox', galleryLightboxController)
  })

  beforeEach(() => {
    document.body.innerHTML = `
      <ul class="gallery-container" data-controller="gallery-lightbox" data-gallery-lightbox-item-selector="${galleryContainerItemSelector}">
        <li class="gallery-image-container">
          <a href="${pathToGalleryItem}">
            <img class="gallery-image-thumbnail" src="${pathToGalleryItem}" alt='${galleryItemDescription}'>
          </a>
        </li>
      </ul>
    `
  })

  afterEach(() => {
    jest.clearAllMocks()
  })

  describe('initialize', () => {
    it('lightbox initialized', () => {
      expect(SimpleLightbox).toHaveBeenCalledWith(galleryContainerItemSelector, {})
    })
  })
})
