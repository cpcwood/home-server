describe 'Views' do
  describe '/admin/projects/:id/edit rendering' do
    context 'edit view' do
      it 'it renders projects' do
        project = create(:project)
        assign(:project, project)
        render template: '/admin/projects/edit.html.erb'

        expect(rendered).to match('project_title')
        expect(rendered).to match('project_overview')
        expect(rendered).to match('project_snippet')
        expect(rendered).to match('project_extension')
        expect(rendered).to match('project_github_link')
        expect(rendered).to match('project_site_link')
        expect(rendered).to match('New main project image')
        expect(rendered).to match('[main_project_image_attributes][image_file]')
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

      it 'main-image-attached' do
        main_image = create(:project_image)
        project = create(:project, main_image_id: main_image.id)
        assign(:project, project)
        render template: '/admin/projects/edit.html.erb'

        expect(rendered).to match('Main project image')
        expect(rendered).to match('Remove image')
      end
    end
  end
end