import { Application } from 'stimulus'
import imageLoaderController from 'controllers/image_loader_controller'

describe('touch_hover_tile_controller', () => {
  const targetLoaded = 2
  let fadeTargetOne
  let fadeTargetTwo

  beforeAll(() => {
    const application = Application.start()
    application.register('image-loader', imageLoaderController)
  })

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller="image-loader" data-image-loader-num-images="${targetLoaded}">
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
    })
  })
})
