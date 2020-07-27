import { Application } from 'stimulus'
import Typed from 'typed.js'
import typedHeaderController from 'controllers/typed_header_controller'
jest.mock('typed.js')

describe('typed_header_controller', () => {
  let application

  beforeAll(() => {
    application = Application.start()
    application.register('typed-header', typedHeaderController)
  })

  beforeEach(() => {
    document.body.innerHTML = `
    <div id="container">
      <div id="controllerDiv" data-controller="typed-header">
        <div id="typed-strings-header">
          <p> Typed header </p>
        </div>
        <span id="typed-header" data-target="typed-header.typedHeader"></span>
        <div id="typed-strings-subtitle">
          <p> Typed subtitle </p>
        </div>
        <span id="typed-subtitle" data-target="typed-header.typedSubtitle"></span>
      </div>
    </div>
    `
  })

  afterEach(() => {
    jest.resetAllMocks()
  })

  afterAll(() => {
    application.unload('typed-header')
  })

  describe('#connect', () => {
    it('typed object initialized', () => {
      expect(Typed).toHaveBeenCalledTimes(1)
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
