describe 'Views' do
  let(:user) { build_stubbed(:user) }
  let(:profile_image) { build_stubbed(:profile_image) }
  let(:about) { build_stubbed(:about) }
  let(:about_attached_image) { build_stubbed(:about, profile_image: profile_image) }

  describe '/about rendering' do
    it 'show view' do
      assign(:about, about)

      render template: 'abouts/show'

      expect(rendered).to match(about.about_me)
      expect(rendered).not_to match('toolbar-container')
    end

    it 'user signed in' do
      assign(:about, about)
      assign(:user, user)

      render template: 'abouts/show'
      expect(rendered).to match('toolbar-container')
    end
  end
end
