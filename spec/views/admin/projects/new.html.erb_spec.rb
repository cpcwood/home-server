describe 'Views' do
  let(:project) { build(:project) }

  describe '/admin/projects/new rendering' do
    context 'new view' do
      before(:each) do
        assign(:project, project)
        render template: '/admin/projects/new.html.erb'
      end

      it 'it renders projects' do
        expect(rendered).to match('project_title')
        expect(rendered).to match('project_overview')
        expect(rendered).to match('project_snippet')
        expect(rendered).to match('project_extension')
        expect(rendered).to match('project_github_link')
        expect(rendered).to match('project_site_link')
        expect(rendered).to match('[main_project_image_attributes][image_file]')
        expect(rendered).to match(admin_projects_path(Project.new))
      end
    end
  end
end