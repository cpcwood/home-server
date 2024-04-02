/**
 * @jest-environment jsdom
 */

import { Application } from '@hotwired/stimulus'
import reCaptchaController from 'controllers/recaptcha_controller'

describe('recaptcha_controller', () => {
  let application
  let mock
  let createElementSpy
  let appendChildSpy
  let removeChildSpyHead
  let mockGrecaptcha

  beforeAll(() => {
    application = Application.start()
    application.register('recaptcha', reCaptchaController)
  })

  afterEach(() => {
    jest.restoreAllMocks()
    document.innerHTML = ''
    window.grecaptcha = null
  })

  describe('#connect', () => {
    beforeEach(() => {
      appendChildSpy = jest.spyOn(document.head, 'appendChild').mockReturnValue(null)
      mock = { src: null, className: null }
      createElementSpy = jest.spyOn(document, 'createElement').mockReturnValue(mock)
      document.body.innerHTML = `
        <div class='recaptcha' id='recaptcha' data-controller='recaptcha' data-recaptcha-target='container'></div>
      `
    })

    it('grecaptcha not loaded', () => {
      expect(createElementSpy).toHaveBeenCalledWith('script')
      expect(mock.src).toEqual('https://www.google.com/recaptcha/api.js?onload=reCaptchaOnload&render=explicit')
      expect(mock.className).toEqual('recaptcha-script')
      expect(appendChildSpy).toHaveBeenCalled()
    })
  })

  describe('#connect', () => {
    beforeEach(() => {
      createElementSpy = jest.spyOn(document, 'createElement')
      mockGrecaptcha = {
        reset: jest.fn(),
        render: jest.fn()
      }
      window.grecaptcha = mockGrecaptcha
      document.body.innerHTML = `
        <div class='recaptcha' id='recaptcha' data-controller='recaptcha' data-recaptcha-target='container'></div>
      `
    })

    it('grecaptcha already loaded', () => {
      expect(createElementSpy).not.toHaveBeenCalled()
      expect(mockGrecaptcha.render).toHaveBeenCalled()
    })
  })

  describe('#disconnect', () => {
    beforeEach(() => {
      removeChildSpyHead = jest.spyOn(document.head, 'removeChild').mockReturnValue(null)
      document.body.innerHTML = `
        <div class='recaptcha' id='recaptcha' data-controller='recaptcha' data-recaptcha-target='container'></div>
      `
    })

    it('removes reCaptchaScript from head on disconnect', () => {
      application.unload('recaptcha')
      expect(removeChildSpyHead).toHaveBeenCalled()
    })
  })
})
