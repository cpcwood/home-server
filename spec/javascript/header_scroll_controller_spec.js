import { Application } from 'stimulus'
import headerScrollController from 'controllers/header_scroll_controller'
const fs = require('fs')

describe("header_scroll_controller", () => {
  let headerImage
  let contentContainer
  let applicationHTML

  beforeAll(done => {
    const application = Application.start()
    application.register("header-scroll", headerScrollController)
    fs.readFile("app/views/layouts/application.html.erb", 'utf8', (err, data) => {
      applicationHTML = data
      done()
    })
  })

  beforeEach(() => {
    document.body.innerHTML = applicationHTML
    headerImage = document.querySelector(".header_image")
    contentContainer = document.querySelector(".content_container")
  })

  describe("#scrollHeaderImage", () => {
    it("headerImage starts with height of 300px", () => {
      contentContainer.scrollTop = 0;
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual('300px')
    })

    it("headerImage height reduces proportionally with contentContainer scroll height", () => {
      contentContainer.scrollTop = 10;
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual('290px')
      contentContainer.scrollTop = 100;
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual('200px')
    })

    it("if contentContainer scroll height >= 240, headerImage height is 60px", () => {
      contentContainer.scrollTop = 240
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual('60px')
      contentContainer.scrollTop = 241
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.height).toEqual('60px')
    })

    it("if contentContainer scroll height < 240, headerImage z-index = -1", () => {
      contentContainer.scrollTop = 0
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.zIndex).toEqual('-1')
      contentContainer.scrollTop = 239
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.zIndex).toEqual('-1')
    })

    it("if contentContainer scroll height >= 240, headerImage z-index = 2", () => {
      contentContainer.scrollTop = 240
      contentContainer.dispatchEvent(new Event('scroll'))
      expect(headerImage.style.zIndex).toEqual('2')
    })
  })
})