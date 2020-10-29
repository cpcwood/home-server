describe 'Views' do
  let(:user) { build_stubbed(:user) }
  let(:project1) { build_stubbed(:project) }
  let(:project2) { build_stubbed(:project) }
  let(:projects) { [project1, project2] }

  describe '/admin/projects rendering' do
    before(:each) do
      assign(:projects, projects)
      assign(:user, user)
      render template: 'admin/projects/index.html.erb'
    end

    it 'index view' do
      expect(rendered).to match(project1.title)
      expect(rendered).to match(project2.title)
      expect(rendered).to match(project1.overview)
      expect(rendered).to match(project2.overview)
      expect(rendered).to match('toolbar-container')
    end

    it 'no projects' do
      assign(:projects, [])
      render template: 'admin/projects/index.html.erb'
      expect(rendered).to match('There are no projects here...')
    end
  end
end