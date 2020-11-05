describe 'Views' do
  let(:user) { build_stubbed(:user) }
  let(:project1) { build_stubbed(:project) }
  let(:project2) { build_stubbed(:project) }
  let(:projects) { [project1, project2] }

  describe '/projects rendering' do
    it 'index view' do
      assign(:projects, projects)

      render template: 'projects/index.html.erb'

      expect(rendered).to match(project1.title)
      expect(rendered).to match(project2.title)
      expect(rendered).to match(project1.overview)
      expect(rendered).to match(project2.overview)
      expect(rendered).to match(project1.github_link)
      expect(rendered).to match(project2.github_link)
      expect(rendered).to match(project1.site_link)
      expect(rendered).to match(project2.site_link)
      expect(rendered).not_to match('toolbar-container')
    end

    it 'no projects' do
      assign(:projects, [])
      render template: 'projects/index.html.erb'
      expect(rendered).to match('There are no projects here...')
    end

    it 'user signed in' do
      assign(:projects, projects)
      assign(:user, user)

      render template: 'projects/index.html.erb'
      expect(rendered).to match('toolbar-container')
    end
  end
end