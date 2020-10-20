import { Application } from 'stimulus'
import reCaptchaController from 'controllers/recaptcha_controller'

describe('recaptcha_controller', () => {
  let application
  let mock
  let createElementSpy
  let appendChildSpy
  let removeChildSpy

  beforeAll(() => {
    application = Application.start()
    application.register('recaptcha', reCaptchaController)
  })

  afterAll(() => {
    jest.clearAllMocks()
    application.unload('recaptcha')
  })

  beforeEach(() => {
    appendChildSpy = jest.spyOn(document.head, 'appendChild').mockReturnValue(null)
    removeChildSpy = jest.spyOn(document.head, 'removeChild').mockReturnValue(null)
    mock = { src: null, className: null }
    createElementSpy = jest.spyOn(document, 'createElement').mockReturnValue(mock)
    document.body.innerHTML = `
      <div class='recaptcha' id='recaptcha' data-controller='recaptcha'></div>
    `
  })

  describe('#connect', () => {
    it('loads requests google recaptcha script', () => {
      expect(createElementSpy).toHaveBeenCalledWith('script')
      expect(mock.src).toEqual('https://www.google.com/recaptcha/api.js?onload=reCaptchaOnload&render=explicit')
      expect(mock.className).toEqual('recaptcha-script')
      expect(appendChildSpy).toHaveBeenCalled()
    })
  })

  describe('#disconnect', () => {
    beforeEach(() => {
      document.body.innerHTML = ''
    })

    it('removes reCaptchaScript from head on disconnect', () => {
      expect(removeChildSpy).toHaveBeenCalled()
    })
  })
})
