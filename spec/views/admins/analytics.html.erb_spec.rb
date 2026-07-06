describe 'Views' do
  let(:user) { build_stubbed(:user) }

  describe 'admins/analytics rendering' do
    it 'Displays analytics metrics' do
      assign(:user, user)
      assign(:period, '30d')
      assign(:metrics, {
               visits_per_day: { Date.new(2026, 7, 4) => 12, Date.new(2026, 7, 5) => 34 },
               unique_visitors_per_day: { Date.new(2026, 7, 4) => 8, Date.new(2026, 7, 5) => 20 },
               top_landing_pages: [['/', 42], ['/about', 17]],
               top_referrers: [['google.com', 25], ['direct', 10]],
               top_countries: [['United Kingdom', 30], ['United States', 12]],
               top_cities: [['London', 18], ['Manchester', 6]],
               device_breakdown: [['Desktop', 40], ['Mobile', 22]],
               browser_breakdown: [['Chrome', 35], ['Safari', 15]],
               os_breakdown: [['macOS', 28], ['Windows', 20]]
             })

      render template: 'admins/analytics'

      expect(rendered).to match(/Visits/)
      expect(rendered).to match(/United Kingdom/)
      expect(rendered).to match(/London/)
    end
  end
end
