describe AdminLinkHelper do
  let(:about) { create(:about) }
  let(:posts) do
    user = create(:user)
    create(:post, user: user)
    create(:post, user: user)
    Post.all
  end

  describe '#admin_link_helper_admin_path' do
    it 'singular resource' do
      expect(helper.admin_link_helper_admin_path(about, true)).to eq(edit_admin_about_path)
    end

    it 'resources' do
      expect(helper.admin_link_helper_admin_path(about)).to eq(edit_admin_about_path(about))
    end

    it 'collection' do
      expect(helper.admin_link_helper_admin_path(posts)).to eq(admin_posts_path)
    end
  end

  describe '#admin_link_helper_section_path' do
    it 'singular model' do
      expect(helper.admin_link_helper_section_path(about)).to eq(about_path)
    end

    it 'collection' do
      expect(helper.admin_link_helper_section_path(posts)).to eq(posts_path)
    end
  end

  describe '#admin_link_helper_new_path' do
    it 'collection' do
      expect(helper.admin_link_helper_new_path(posts)).to eq(new_admin_post_path)
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
end