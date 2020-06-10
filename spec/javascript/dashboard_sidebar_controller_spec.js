import { Application } from 'stimulus'
import dashboardSidebarController from 'controllers/dashboard_sidebar_controller'
const fs = require('fs')

describe("dashboard_sidebar_controller", () => {
  let dashboardSidebar
  let dashboardSidebarToggle
  let applicationHTML

  beforeAll(done => {
    const application = Application.start()
    application.register("dashboard-sidebar", dashboardSidebarController)
    fs.readFile("app/views/admin/_dashboard_sidebar.html.erb", 'utf8', (err, data) => {
      applicationHTML = data
      done()
    })
  })

  beforeEach(() => {
    document.body.innerHTML = applicationHTML
    dashboardSidebar = document.querySelector(".dashboard_sidebar")
    dashboardSidebarToggle = document.querySelector(".dashboard_sidebar_toggle")
  })

  describe("#sidebarToggle", () => {
    it("on toggle click - adds and removes 'open' class to sidebarToggleTarget", () => {
      dashboardSidebarToggle.click()
      expect(dashboardSidebarToggle.classList).toContain('open')
      dashboardSidebarToggle.click()
      expect(dashboardSidebarToggle.classList).not.toContain('open')
    })

    it("on toggle click - adds and removes 'open' class to sidebarTarget", () => {
      dashboardSidebarToggle.click()
      expect(dashboardSidebar.classList).toContain('open')
      dashboardSidebarToggle.click()
      expect(dashboardSidebar.classList).not.toContain('open')
    })

    it("on toggle click - sidebar open state added to controller element", () => {
      expect(dashboardSidebar.getAttribute('data-dashboard-sidebar-open')).toEqual('false')
      dashboardSidebarToggle.click()
      expect(dashboardSidebar.getAttribute('data-dashboard-sidebar-open')).toEqual('true')
      dashboardSidebarToggle.click()
      expect(dashboardSidebar.getAttribute('data-dashboard-sidebar-open')).toEqual('false')
    })
  })
})