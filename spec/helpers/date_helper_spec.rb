describe DateHelper do
  let(:date) { Date.new(2020, 04, 19) }

  describe '#full_date' do
    it 'process to html' do
      result = helper.full_date(date)
      expect(result).to eq('<span>April 19<sup>th</sup>, 2020</span>')
      ap result.class
      expect(result).to be_kind_of(ActiveSupport::SafeBuffer)
    end
  end
end
