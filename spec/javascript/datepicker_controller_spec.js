
import { Application } from 'stimulus'
import datepickerController from 'controllers/datepicker_controller'

import Pikaday from 'pikaday/pikaday.js'
jest.mock('pikaday/pikaday.js')

describe('recaptcha_controller', () => {
  let application
  let dateField

  beforeAll(() => {
    application = Application.start()
    application.register('datepicker', datepickerController)
  })

  afterAll(() => {
    jest.clearAllMocks()
  })

  beforeEach(() => {
    document.body.innerHTML = '<input data-controller="datepicker" data-target="datepicker.dateField" type="text">'
    dateField = document.body.childNodes[0]
  })

  describe('#connect', () => {
    it('datepicker.js initialized', () => {
      expect(Pikaday).toHaveBeenCalledWith({ field: dateField })
    })
  })
})
