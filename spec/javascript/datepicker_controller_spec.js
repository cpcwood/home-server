
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

  beforeEach(() => {
    document.body.innerHTML = '<input data-controller="datepicker" data-target="datepicker.dateField" type="text">'
    dateField = document.body.childNodes[0]
  })

  afterEach(() => {
    jest.clearAllMocks()
  })

  describe('#connect', () => {
    it('datepicker.js initialized', () => {
      expect(Pikaday).toHaveBeenCalledWith({ field: dateField })
    })
  })

  describe('#disconnect', () => {
    beforeEach(() => {
      document.body.innerHTML = ''
    })

    it('datepicker.js destroyed', () => {
      const mockPikadayInstance = Pikaday.mock.instances[0]
      expect(mockPikadayInstance.destroy).toHaveBeenCalledTimes(1)
    })
  })
})
