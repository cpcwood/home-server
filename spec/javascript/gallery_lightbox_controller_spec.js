/**
 * @jest-environment jsdom
 */

import { Application } from '@hotwired/stimulus'
import galleryLightboxController from 'controllers/gallery_lightbox_controller'
import SimpleLightbox from 'simplelightbox'

const mockSimpleLightbox = { destroy: jest.fn() }

jest.mock('simplelightbox', () => {
  return jest.fn().mockImplementation(() => {
    return mockSimpleLightbox
  })
})

describe('gallery_lightbox_controller', () => {
  const galleryContainerItemSelector = '.gallery-container a'
  const pathToGalleryItem = 'path-to-full-image.jpg'
  const galleryItemDescription = 'gallery item description'
  let container

  beforeAll(() => {
    const application = Application.start()
    application.register('gallery-lightbox', galleryLightboxController)
  })

  beforeEach(() => {
    document.body.innerHTML = `
    <ul class="gallery-container" data-controller="gallery-lightbox" data-gallery-lightbox-item-selector="${galleryContainerItemSelector}" data-action='reConnectLightbox->gallery-lightbox#reConnect'>
      <li class="gallery-image-container">
        <a href="${pathToGalleryItem}">
          <img class="gallery-image-thumbnail" src="${pathToGalleryItem}" alt='${galleryItemDescription}'>
        </a>
      </li>
    </ul>
    `
    container = document.querySelector('.gallery-container')
  })

  afterEach(() => {
    jest.clearAllMocks()
  })

  describe('#connect', () => {
    it('lightbox initialized', () => {
      expect(SimpleLightbox).toHaveBeenCalledWith(galleryContainerItemSelector, {
        animationSlide: false,
        animationSpeed: 100,
        captionClass: 'lightbox-caption',
        close: false,
        fadeSpeed: 150,
        history: false,
        htmlClass: false,
        showCounter: false
      })
    })
  })

  describe('#reConnect', () => {
    it('lightbox destroyed and reinitialized', () => {
      container.dispatchEvent(new Event('reConnectLightbox'))
      expect(mockSimpleLightbox.destroy).toHaveBeenCalled()
    })
  })
})
