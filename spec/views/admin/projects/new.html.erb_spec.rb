describe 'Views' do
  describe '/admin/projects/new rendering' do
    context 'new view' do
      it 'it renders projects' do
        project = build(:project)
        assign(:project, project)
        render template: '/admin/projects/new'

        expect(rendered).to match('project_title')
        expect(rendered).to match('project_overview')
        expect(rendered).to match('project_github_link')
        expect(rendered).to match('project_site_link')
        expect(rendered).to match('[project_image_attributes][image_file]')
        expect(rendered).to match(admin_projects_path(Project.new))
      end
    end
  end
end