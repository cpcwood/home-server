require 'rails_helper'

RSpec.describe AnalyticsService do
  describe '.metrics' do
    before do
      create(:visit, started_at: 2.days.ago)
      create(:visit, started_at: 2.days.ago, visitor_token: 'repeat', country: 'France', city: 'Paris', device_type: 'Mobile')
      create(:visit, started_at: 2.days.ago, visitor_token: 'repeat')
      create(:visit, started_at: 60.days.ago)
    end

    it 'counts visits inside the period only' do
      expect(described_class.metrics('30d')[:visits_per_day].values.sum).to eq(3)
    end

    it 'counts unique visitors' do
      expect(described_class.metrics('30d')[:unique_visitors_per_day].values.sum).to eq(2)
    end

    it 'ranks countries' do
      expect(described_class.metrics('30d')[:top_countries].first(2)).to eq([['United Kingdom', 2], ['France', 1]])
    end

    it 'falls back to 30d for unknown periods' do
      expect(described_class.metrics('bogus')[:visits_per_day].values.sum).to eq(3)
    end

    it 'includes the other breakdowns' do
      metrics = described_class.metrics('90d')
      expect(metrics[:top_landing_pages].first.first).to eq('https://cpcwood.com/blog')
      expect(metrics[:top_referrers].first.first).to eq('duckduckgo.com')
      expect(metrics[:device_breakdown]).to include(['Desktop', 3], ['Mobile', 1])
      expect(metrics[:browser_breakdown].first.first).to eq('Firefox')
      expect(metrics[:os_breakdown].first.first).to eq('GNU/Linux')
      expect(metrics[:top_cities].first.first).to eq('London')
    end

    it 'excludes visits with blank technology fields from the breakdowns' do
      create(:visit, started_at: 2.days.ago, device_type: nil, browser: nil, os: nil)
      metrics = described_class.metrics('30d')
      expect(metrics[:device_breakdown].map(&:first)).not_to include(nil, '')
      expect(metrics[:browser_breakdown].map(&:first)).not_to include(nil, '')
      expect(metrics[:os_breakdown].map(&:first)).not_to include(nil, '')
    end
  end
end
