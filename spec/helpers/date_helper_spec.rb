describe DateHelper do
  let(:date) { Date.new(2020, 04, 19) }
  let(:datetime) { DateTime.new(2020, 04, 19, 01, 02, 03) }

  describe '#full_date' do
    it 'process to html' do
      result = helper.full_date(date)
      expect(result).to eq('<span>April 19<sup>th</sup>, 2020</span>')
      expect(result).to be_kind_of(ActiveSupport::SafeBuffer)
    end
  end

  describe '#full_date_and_time' do
    it 'process to html' do
      result = helper.full_date_and_time(datetime)
      expect(result).to eq('<span>April 19<sup>th</sup>, 2020 at 1:02am</span>')
      expect(result).to be_kind_of(ActiveSupport::SafeBuffer)
    end
  end
end
