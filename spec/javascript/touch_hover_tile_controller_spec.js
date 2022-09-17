/**
 * @jest-environment jsdom
 */

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
      <div class="flex-image-tile" data-controller="touch-hover-tile" data-action="touchstart->touch-hover-tile#touchStart:passive touchend->touch-hover-tile#touchEnd:passive mouseenter->touch-hover-tile#applyHoverToTarget mouseleave->touch-hover-tile#teardown">
        <img class="cover-image">
        <a href="/one">
          <span class="cover-title" data-touch-hover-tile-target="coverTitle">
            <span>flexTileOne</span>
          </span>
        </a>
      </div>
      <div class="flex-image-tile" data-controller="touch-hover-tile" data-action="touchstart->touch-hover-tile#touchStart:passive touchend->touch-hover-tile#touchEnd:passive mouseenter->touch-hover-tile#applyHoverToTarget mouseleave->touch-hover-tile#teardown">
        <img class="cover-image">
        <a href="/two">
          <span class="cover-title" data-touch-hover-tile-target="coverTitle">
            <span>flexTileTwo</span>
          </span>
        </a>
      </div>
    `
    const flexImageTiles = document.getElementsByClassName('flex-image-tile')
    flexImageTileOne = flexImageTiles[0]
    flexImageTileTwo = flexImageTiles[1]
  })

  afterEach(() => {
    jest.resetAllMocks()
  })

  describe('touch events', () => {
    const touchTime = 249

    it('touch < touchTime', () => {
      jest.spyOn(Date, 'now').mockReturnValueOnce(new Date('2020-04-19T00:00:00.000')).mockReturnValue(new Date(`2020-04-19T00:00:00.${touchTime}`))
      flexImageTileOne.dispatchEvent(new Event('touchstart'))
      flexImageTileOne.dispatchEvent(new Event('touchend'))

      expect(flexImageTileOne.querySelector('.cover-title').classList).toContain('hover')
    })

    it('touch >= touchTime', () => {
      jest.spyOn(Date, 'now').mockReturnValueOnce(new Date('2020-04-19T00:00:00.000')).mockReturnValue(new Date(`2020-04-19T00:00:00.${touchTime + 1}`))
      flexImageTileOne.dispatchEvent(new Event('touchstart'))
      flexImageTileOne.dispatchEvent(new Event('touchend'))

      expect(flexImageTileOne.querySelector('.cover-title').classList).not.toContain('hover')
    })

    it('other tile already being hovered on', () => {
      let dateMock = jest.spyOn(Date, 'now').mockReturnValueOnce(new Date('2020-04-19T00:00:00.000')).mockReturnValue(new Date(`2020-04-19T00:00:00.${touchTime}`))
      flexImageTileOne.dispatchEvent(new Event('touchstart'))
      flexImageTileOne.dispatchEvent(new Event('touchend'))

      dateMock.mockRestore()
      dateMock = jest.spyOn(Date, 'now').mockReturnValueOnce(new Date('2020-04-19T00:00:00.000')).mockReturnValue(new Date(`2020-04-19T00:00:00.${touchTime}`))
      flexImageTileTwo.dispatchEvent(new Event('touchstart'))
      flexImageTileTwo.dispatchEvent(new Event('touchend'))

      expect(flexImageTileTwo.querySelector('.cover-title').classList).toContain('hover')
      expect(flexImageTileOne.querySelector('.cover-title').classList).not.toContain('hover')
    })
  })

  describe('mouse events', () => {
    it('mouseenter event', () => {
      flexImageTileOne.dispatchEvent(new Event('mouseenter'))
      expect(flexImageTileOne.querySelector('.cover-title').classList).toContain('hover')
    })

    it('mouseleave event', () => {
      flexImageTileOne.dispatchEvent(new Event('mouseenter'))
      flexImageTileOne.dispatchEvent(new Event('mouseleave'))
      expect(flexImageTileOne.querySelector('.cover-title').classList).not.toContain('hover')
    })

    it('other tile already being hovered on', () => {
      flexImageTileOne.dispatchEvent(new Event('mouseenter'))
      flexImageTileTwo.dispatchEvent(new Event('mouseenter'))
      expect(flexImageTileOne.querySelector('.cover-title').classList).not.toContain('hover')
      expect(flexImageTileTwo.querySelector('.cover-title').classList).toContain('hover')
    })
  })
})
