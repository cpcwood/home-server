import { Application } from 'stimulus'
import dashboardSidebarController from 'controllers/dashboard_sidebar_controller'

describe("dashboard_sidebar_controller", () => {
  var dashboardSidebar;
  var dashboardSidebarToggle;

  beforeAll(() => {
    const application = Application.start()
    application.register("dashboard-sidebar", dashboardSidebarController)
  })

  beforeEach(() => {
    document.body.innerHTML = `
      <div class='dashboard_sidebar' data-controller='dashboard-sidebar' data-target='dashboard-sidebar.sidebar' data-dashboard-sidebar-open='false'>
        <div class='dashboard_sidebar_toggle' data-action='click->dashboard-sidebar#sidebarToggle' data-target='dashboard-sidebar.sidebarToggle'></div>
      </div>
    `
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