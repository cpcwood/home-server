describe ApplicationHelper do
  describe '#header_height' do
    it 'homepage path' do
      mock_params = {
        controller: 'homepages'
      }
      allow(helper).to receive(:params).and_return(mock_params)
      expect(helper.header_height).to eq(300)
    end

    it 'admin path' do
      mock_params = {
        controller: 'admin'
      }
      allow(helper).to receive(:params).and_return(mock_params)
      expect(helper.header_height).to eq(300)
    end

    it 'admin scope path' do
      mock_params = {
        controller: 'admin/gallery'
      }
      allow(helper).to receive(:params).and_return(mock_params)
      expect(helper.header_height).to eq(300)
    end

    it 'other path' do
      mock_params = {
        controller: 'other'
      }
      allow(helper).to receive(:params).and_return(mock_params)
      expect(helper.header_height).to eq(205)
    end
  end
end