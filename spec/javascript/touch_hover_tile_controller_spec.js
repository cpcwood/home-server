import { Application } from 'stimulus'
import touchHoverTileController from 'controllers/touch_hover_tile_controller'

describe('touch_hover_tile_controller', () => {
  let flexImageTileOne
  let flexImageTileTwo

  beforeAll(() => {
    const application = Application.start()
    application.register('touch-hover-tile', touchHoverTileController)
  })

  beforeEach(() => {
    document.body.innerHTML = `
      <div class="flex_image_tile" data-controller="touch-hover-tile" data-action="touchstart->touch-hover-tile#checkTouch touchend->touch-hover-tile#addHover">
        <img class="cover_image">
        <a href="/one">
          <span class="cover_title" data-target="touch-hover-tile.coverTitle">
            <span>flexTileOne</span>
          </span>
        </a>
      </div>
      <div class="flex_image_tile" data-controller="touch-hover-tile" data-action="touchstart->touch-hover-tile#checkTouch touchend->touch-hover-tile#addHover">
        <img class="cover_image">
        <a href="/two">
          <span class="cover_title" data-target="touch-hover-tile.coverTitle">
            <span>flexTileTwo</span>
          </span>
        </a>
      </div>
    `
    const flexImageTiles = document.getElementsByClassName('flex_image_tile')
    flexImageTileOne = flexImageTiles[0]
    flexImageTileTwo = flexImageTiles[1]
  })

  afterEach(() => {
    jest.resetAllMocks()
  })

  describe('#addHover', () => {
    it("touch < 250ms adds 'hover' class to child coverTile", () => {
      jest.spyOn(Date, 'now').mockReturnValueOnce(new Date('2020-04-19T00:00:00.000')).mockReturnValue(new Date('2020-04-19T00:00:00.249'))
      flexImageTileOne.dispatchEvent(new Event('touchstart'))
      flexImageTileOne.dispatchEvent(new Event('touchend'))

      expect(flexImageTileOne.querySelector('.cover_title').classList).toContain('hover')
    })

    it('touch >= 250ms performs default', () => {
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
