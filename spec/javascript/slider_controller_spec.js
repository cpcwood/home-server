import { Application } from 'stimulus'
import sliderController from 'controllers/slider_controller'
import { fireEvent } from '@testing-library/dom'

describe('slider_controller', () => {
  let application
  let sliderInput
  let sliderValue

  beforeAll(() => {
    application = Application.start()
    application.register('slider', sliderController)
  })

  afterAll(() => {
    jest.clearAllMocks()
    application.unload('slider')
  })

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller="slider">
        <input min="0" max="100" value="50" class="slider-input" data-action="input->slider#update" data-target="slider.input" type="range">
        <span class="slider-value" data-target="slider.value">50</span>
      </div>
    `
    sliderInput = document.querySelector('.slider-input')
    sliderValue = document.querySelector('.slider-value')
  })

  describe('#update', () => {
    it('Updates slider value entry on page', () => {
      fireEvent.input(sliderInput, { target: { value: 25 } })
      expect(sliderValue.innerHTML).toEqual('25')
    })
  })
})
