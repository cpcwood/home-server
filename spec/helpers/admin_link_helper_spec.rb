describe AdminLinkHelper do
  describe '#admin_link_helper_edit_link' do
    it 'simple link' do
      simple_path = '/about'
      request_mock = double(:request, original_fullpath: simple_path)
      allow(helper).to receive(:request).and_return(request_mock)
      expect(helper.admin_link_helper_edit_link).to eq('/admin/about/edit')
    end

    it 'complex link' do
      simple_path = '/test/123/about'
      request_mock = double(:request, original_fullpath: simple_path)
      allow(helper).to receive(:request).and_return(request_mock)
      expect(helper.admin_link_helper_edit_link).to eq('/admin/test/123/about/edit')
    end
  end

  describe '#on_admin_page?' do
    it 'on admin page' do
      simple_path = '/admin'
      request_mock = double(:request, original_fullpath: simple_path)
      allow(helper).to receive(:request).and_return(request_mock)
      expect(helper.on_admin_page?).to eq(true)
    end
  end
end