import { Application } from 'stimulus'
import imageLoaderController from 'controllers/image_loader_controller'

describe('touch_hover_tile_controller', () => {
  let fadeTargetOne
  let fadeTargetTwo

  beforeAll(() => {
    const application = Application.start()
    application.register('image-loader', imageLoaderController)
  })

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller="image-loader" data-target="image-loader.container">
        <img class="fade-target" data-action="load->image-loader#imageLoaded" data-target="image-loader.fade">
        <img class="fade-target" data-action="load->image-loader#imageLoaded" data-target="image-loader.fade">
      </div>
    `
    const fadeTargets = document.getElementsByClassName('fade-target')
    fadeTargetOne = fadeTargets[0]
    fadeTargetTwo = fadeTargets[1]
  })

  describe('#imageLoaded', () => {
    it('not all images loaded', () => {
      fadeTargetOne.dispatchEvent(new Event('load'))
      expect(fadeTargetOne.classList).not.toContain('fade-in')
      expect(fadeTargetTwo.classList).not.toContain('fade-in')
    })

    it('all images loaded', () => {
      fadeTargetOne.dispatchEvent(new Event('load'))
      fadeTargetTwo.dispatchEvent(new Event('load'))
      expect(fadeTargetOne.classList).toContain('fade-in')
      expect(fadeTargetTwo.classList).toContain('fade-in')
      expect(fadeTargetOne.style.transitionDelay).toBe('0s')
      expect(fadeTargetTwo.style.transitionDelay).toBe('0.1s')
    })
  })

  describe('#disconnect', () => {
    beforeEach(() => {
      document.body.innerHTML = ''
    })

    it('classes removed before page cache', () => {
      expect(fadeTargetOne.classList).not.toContain('fade-in')
      expect(fadeTargetTwo.classList).not.toContain('fade-in')
      expect(fadeTargetOne.style.transitionDelay).toBe('')
      expect(fadeTargetTwo.style.transitionDelay).toBe('')
    })
  })
})
