/**
 * @jest-environment jsdom
 */

import { Application } from '@hotwired/stimulus'
import galleryScrollLoadController from 'controllers/gallery_scroll_load_controller'

const flush = () => new Promise(resolve => setTimeout(resolve, 0))

describe('gallery_scroll_load_controller', () => {
  let application
  let container
  let controller

  const imagesData = {
    data: [
      { attributes: { url: '/one', thumbnail_url: '/one.jpg', title: 'One', description: 'One' } },
      { attributes: { url: '/two', thumbnail_url: '/two.jpg', title: 'Two', description: 'Two' } }
    ]
  }

  beforeAll(() => {
    application = Application.start()
    application.register('gallery-scroll-load', galleryScrollLoadController)
  })

  afterAll(() => {
    application.stop()
  })

  beforeEach(async () => {
    document.body.innerHTML = `
      <ul class='gallery-container'
          data-controller='gallery-scroll-load'
          data-gallery-scroll-load-page-value='1'
          data-gallery-scroll-load-api-url-value='/gallery_images'></ul>
    `
    container = document.querySelector('.gallery-container')
    await flush()
    controller = application.getControllerForElementAndIdentifier(container, 'gallery-scroll-load')
  })

  afterEach(async () => {
    await flush()
  })

  describe('#displayGalleryItemTargets', () => {
    it('un-hides new items before dispatching renderGallery so they have measurable dimensions', async () => {
      let hiddenItemsWhenRendered = null
      container.addEventListener('renderGallery', () => {
        hiddenItemsWhenRendered = container.querySelectorAll('.gallery-image-container.hidden').length
      })

      controller.injectImages(imagesData)
      await flush()
      container.querySelectorAll('img').forEach(img => img.dispatchEvent(new Event('load')))
      await flush()

      expect(hiddenItemsWhenRendered).toBe(0)
    })
  })

  describe('#injectImages', () => {
    it('links injected images via the configured link attribute', async () => {
      document.body.innerHTML = `
        <ul class='gallery-container'
            data-controller='gallery-scroll-load'
            data-gallery-scroll-load-page-value='1'
            data-gallery-scroll-load-api-url-value='/admin/gallery'
            data-gallery-scroll-load-link-attribute-value='link_url'></ul>
      `
      container = document.querySelector('.gallery-container')
      await flush()
      controller = application.getControllerForElementAndIdentifier(container, 'gallery-scroll-load')

      controller.injectImages({
        data: [
          { attributes: { url: '/one', thumbnail_url: '/one.jpg', title: 'One', description: 'One', link_url: '/admin/gallery-images/1/edit' } }
        ]
      })
      await flush()

      const anchor = container.querySelector('a.view-gallery-image')
      expect(anchor.href.endsWith('/admin/gallery-images/1/edit')).toBe(true)
    })
  })
})
