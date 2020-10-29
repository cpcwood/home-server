describe 'Views' do
  let(:project) { create(:project) }

  describe '/admin/projects/:id/edit rendering' do
    context 'edit view' do
      before(:each) do
        assign(:project, project)
        render template: '/admin/projects/edit.html.erb'
      end

      it 'it renders projects' do
        expect(rendered).to match('project_title')
        expect(rendered).to match('project_overview')
        expect(rendered).to match('project_snippet')
        expect(rendered).to match('project_extension')
        expect(rendered).to match('project_github_link')
        expect(rendered).to match('project_site_link')
        expect(rendered).to match(project.title)
        expect(rendered).to match(project.overview)
        expect(rendered).to match(project.snippet)
        expect(rendered).to match(project.extension)
        expect(rendered).to match(project.github_link)
        expect(rendered).to match(project.site_link)
        expect(rendered).to match(admin_project_path(project))
        expect(rendered).to match('Return')
        expect(rendered).to match(admin_projects_path)
        expect(rendered).to match('Remove')
      end
    end
  end
end