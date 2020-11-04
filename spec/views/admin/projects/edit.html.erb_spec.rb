describe 'Views' do
  describe '/admin/projects/:id/edit rendering' do
    context 'edit view' do
      it 'it renders projects' do
        project = create(:project)
        assign(:project, project)
        render template: '/admin/projects/edit.html.erb'

        expect(rendered).to match('project_title')
        expect(rendered).to match('project_overview')
        expect(rendered).to match('project_github_link')
        expect(rendered).to match('project_site_link')
        expect(rendered).to match('[project_image_attributes][image_file]')
        expect(rendered).to match(project.title)
        expect(rendered).to match(project.overview)
        expect(rendered).to match(project.github_link)
        expect(rendered).to match(project.site_link)
        expect(rendered).to match(admin_project_path(project))
        expect(rendered).to match('Return')
        expect(rendered).to match(admin_projects_path)
        expect(rendered).to match('Remove')
      end

      it 'project-image-attached' do
        project = create(:project)
        project_image = project.project_images.create(title: 'test')
        assign(:project, project)
        render template: '/admin/projects/edit.html.erb'

        expect(rendered).to match('Project image')
        expect(rendered).to match('Remove image')
        expect(rendered).to match(project_image.title)
      end
    end
  end
end