describe AdminLinkHelper do
  describe '#admin_link_helper_edit_link' do
    it 'simple path' do
      path = '/about'
      request_mock = double(:request, original_fullpath: path)
      allow(helper).to receive(:request).and_return(request_mock)
      expect(helper.admin_link_helper_edit_link).to eq('/admin/about/edit')
    end

    it 'complex path' do
      simple_path = '/test/123/about'
      request_mock = double(:request, original_fullpath: simple_path)
      allow(helper).to receive(:request).and_return(request_mock)
      expect(helper.admin_link_helper_edit_link).to eq('/admin/test/123/about/edit')
    end
  end

  describe '#admin_link_helper_index_link' do
    it 'path modified' do
      path = '/blog'
      request_mock = double(:request, original_fullpath: path)
      allow(helper).to receive(:request).and_return(request_mock)
      expect(helper.admin_link_helper_index_link).to eq('/admin/blog')
    end
  end

  describe '#in_admin_scope?' do
    it 'in admin scope' do
      path = '/admin/some-page'
      request_mock = double(:request, original_fullpath: path)
      allow(helper).to receive(:request).and_return(request_mock)
      expect(helper.in_admin_scope?).to eq(true)
    end

    it 'not in admin scope - simple' do
      path = '/some-page'
      request_mock = double(:request, original_fullpath: path)
      allow(helper).to receive(:request).and_return(request_mock)
      expect(helper.in_admin_scope?).to eq(false)
    end

    it 'not in admin scope - edge' do
      path = '/admin-not-admin/'
      request_mock = double(:request, original_fullpath: path)
      allow(helper).to receive(:request).and_return(request_mock)
      expect(helper.in_admin_scope?).to eq(false)
    end
  end

  describe '#admin_link_helper_return_link' do
    it 'simple path' do
      path = '/admin/about'
      request_mock = double(:request, original_fullpath: path)
      allow(helper).to receive(:request).and_return(request_mock)
      expect(helper.admin_link_helper_return_link).to eq('/about')
    end

    it 'edit view' do
      path = '/admin/about/1/edit'
      request_mock = double(:request, original_fullpath: path)
      allow(helper).to receive(:request).and_return(request_mock)
      expect(helper.admin_link_helper_return_link).to eq('/about/1')
    end
  end
end