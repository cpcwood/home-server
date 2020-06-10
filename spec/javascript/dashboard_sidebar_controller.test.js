import { Application } from 'stimulus'
import dashboardSidebarController from 'controllers/dashboard_sidebar_controller'

describe("dashboard_sidebar_controller", () => {
  beforeEach(() => {
    document.body.innerHTML = `
      <div id='dashboard_sidebar' data-controller='dashboard-sidebar' data-target='dashboard-sidebar.sidebar' data-dashboard-sidebar-open='false'>
        <div id='dashboard_sidebar_toggle' data-action='click->dashboard-sidebar#sidebarToggle' data-target='dashboard-sidebar.sidebarToggle'></div>
      </div>
    `
    const application = Application.start()
    application.register("dashboard-sidebar", dashboardSidebarController)
  })

  describe("#sidebarToggle", () => {
    it("click when closed opens sidebar", () => {
      const dashboardSidebar = document.getElementById("dashboard_sidebar")
      const dashboardSidebarToggle = document.getElementById("dashboard_sidebar_toggle")

      expect(dashboardSidebar.getAttribute('data-dashboard-sidebar-open')).toEqual('false')

      dashboardSidebarToggle.click()

      expect(dashboardSidebar.getAttribute('data-dashboard-sidebar-open')).toEqual('true')
    })
  });
});