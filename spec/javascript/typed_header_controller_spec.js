/**
 * @jest-environment jsdom
 */

import { Application } from '@hotwired/stimulus'
import Typed from 'typed.js'
import Cookies from 'js-cookie'
import typedHeaderController from 'controllers/typed_header_controller'
jest.mock('typed.js')
jest.mock('js-cookie')

describe('typed_header_controller', () => {
  let application

  const testHtml = `
  <div id="container">
    <div id="controllerDiv" data-controller="typed-header">
      <div id="typed-strings-header">
        <p data-typed-header-target="typedHeaderText"> 
          Typed header
        </p>
      </div>
      <span id="typed-header" data-typed-header-target="typedHeader"></span>
      <div id="typed-strings-subtitle">
        <p data-typed-header-target="typedSubtitleText"> 
          Typed subtitle 
        </p>
      </div>
      <span id="typed-subtitle" data-typed-header-target="typedSubtitle"></span>
    </div>
  </div>
  `

  beforeAll(() => {
    application = Application.start()
    application.register('typed-header', typedHeaderController)
  })

  afterEach(() => {
    jest.resetAllMocks()
  })

  afterAll(() => {
    application.unload('typed-header')
  })

  describe('first visit', () => {
    beforeEach(() => {
      document.body.innerHTML = testHtml
    })

    describe('#connect', () => {
      it('typed object initialized', () => {
        expect(Typed).toHaveBeenCalledTimes(1)
        expect(Cookies.set).toHaveBeenCalledTimes(1)
      })
    })

    describe('#disconnect', () => {
      beforeEach(() => {
        document.body.innerHTML = 'test'
      })

      it('typed object removed', () => {
        expect(Typed.mock.instances[0].destroy).toHaveBeenCalledTimes(1)
      })
    })
  })

  describe('second visit', () => {
    beforeEach(() => {
      Cookies.get.mockImplementation(() => {
        return 'true'
      })
      document.body.innerHTML = testHtml
    })

    it('strings filled if already typed', () => {
      expect(Typed).toHaveBeenCalledTimes(0)
      expect(Cookies.set).toHaveBeenCalledTimes(1)
    })
  })
})
