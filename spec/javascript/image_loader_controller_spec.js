import { Application } from 'stimulus'
import imageLoaderController from 'controllers/image_loader_controller'

jest.useFakeTimers()

describe('image_loader_controller', () => {
  let fadeTargetOne
  let fadeTargetTwo

  beforeAll(() => {
    const application = Application.start()
    application.register('image-loader', imageLoaderController)
  })

  describe('images present', () => {
    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller="image-loader" data-target="image-loader.container" data-action='turbolinks:before-cache@window->image-loader#teardown'>
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

    describe('#teardown', () => {
      it('reset to cache safe state', () => {
        fadeTargetOne.dispatchEvent(new Event('load'))
        fadeTargetTwo.dispatchEvent(new Event('load'))
        jest.runOnlyPendingTimers()
        window.dispatchEvent(new Event('turbolinks:before-cache'))
        expect(fadeTargetOne.classList).not.toContain('fade-in')
        expect(fadeTargetTwo.classList).not.toContain('fade-in')
        expect(fadeTargetOne.style.transitionDelay).toBe('')
        expect(fadeTargetTwo.style.transitionDelay).toBe('')
      })
    })
  })

  describe('no images', () => {
    let fadeTarget

    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller="image-loader" data-target="image-loader.container" data-action='turbolinks:before-cache@window->image-loader#teardown'>
          <div id="fade-target" data-target="image-loader.fade">
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
