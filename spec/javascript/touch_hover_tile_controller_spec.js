import { Application } from 'stimulus'
import touchHoverTileController from 'controllers/touch_hover_tile_controller'
const fs = require('fs')

describe("touch_hover_tile_controller", () => {
  let applicationHTML
  let flexImageTileOne
  let flexImageTileTwo

  beforeAll(done => {
    const application = Application.start()
    application.register("touch-hover-tile", touchHoverTileController)
    fs.readFile("app/views/homepage/index.html.erb", 'utf8', (err, data) => {
      applicationHTML = data
      done()
    })
  })

  beforeEach(() => {
    document.body.innerHTML = applicationHTML
    let flexImageTiles = document.getElementsByClassName("flex_image_tile")
    flexImageTileOne = flexImageTiles[0]
    flexImageTileTwo = flexImageTiles[1]
  })

  afterEach(() => {
    jest.resetAllMocks()
  })

  describe("#addHover", () => {
    it("touch < 250ms adds 'hover' class to child coverTile", () => { 
      jest.spyOn(Date, 'now').mockReturnValueOnce(new Date('2020-04-19T00:00:00.000')).mockReturnValue(new Date('2020-04-19T00:00:00.249'))
      flexImageTileOne.dispatchEvent(new Event('touchstart'))
      flexImageTileOne.dispatchEvent(new Event('touchend'))

      expect(flexImageTileOne.querySelector('.cover_title').classList).toContain('hover')
    })

    it("touch >= 250ms performs default", () => { 
      jest.spyOn(Date, 'now').mockReturnValueOnce(new Date('2020-04-19T00:00:00.000')).mockReturnValue(new Date('2020-04-19T00:00:00.250'))
      flexImageTileOne.dispatchEvent(new Event('touchstart'))
      flexImageTileOne.dispatchEvent(new Event('touchend'))

      expect(flexImageTileOne.querySelector('.cover_title').classList).not.toContain('hover')
    })

    it("if another tile contains class 'hover' it is removed, and added to tile clicked", () => {
      let dateMock = jest.spyOn(Date, 'now').mockReturnValueOnce(new Date('2020-04-19T00:00:00.000')).mockReturnValue(new Date('2020-04-19T00:00:00.249'))
      flexImageTileOne.dispatchEvent(new Event('touchstart'))
      flexImageTileOne.dispatchEvent(new Event('touchend'))

      dateMock.mockRestore()
      dateMock = jest.spyOn(Date, 'now').mockReturnValueOnce(new Date('2020-04-19T00:00:00.000')).mockReturnValue(new Date('2020-04-19T00:00:00.249'))
      flexImageTileTwo.dispatchEvent(new Event('touchstart'))
      flexImageTileTwo.dispatchEvent(new Event('touchend'))

      expect(flexImageTileTwo.querySelector('.cover_title').classList).toContain('hover')
      expect(flexImageTileOne.querySelector('.cover_title').classList).not.toContain('hover')
    })
  })
})