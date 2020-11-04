RSpec.describe 'AdminProjects', type: :request do
  let(:image_fixture) { fixture_file_upload(Rails.root.join('spec/files/sample_image.jpg'), 'image/png') }

  let(:valid_attributes) do
    { project: {
      title: 'new project',
      overview: 'project overview',
      date: DateTime.new(2020, 04, 19, 0, 0, 0),
      github_link: 'https://example.com/github',
      site_link: 'https://example.com/site'
    }}
  end

  let(:new_image_upload_attributes) do
    new_image_upload_attributes = valid_attributes
    new_image_upload_attributes[:new_project_images] = {
      image_files: [
        image_fixture
      ]
    }
    new_image_upload_attributes
  end

  let(:invalid_attributes) do
    invalid_attributes = valid_attributes
    invalid_attributes[:project][:title] = ''
    invalid_attributes
  end

  before(:each) do
    seed_user_and_settings
    login
  end

  describe 'GET /admin/projects #index' do
    it 'succesful request' do
      get('/admin/projects')
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /admin/projects/new #index' do
    it 'sucessful request' do
      get '/admin/projects/new'
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /admin/projects #create' do
    it 'sucessful request' do
      expect{ post('/admin/projects', params: valid_attributes) }.to change{
        Project.all.length
      }.from(0).to(1)
      expect(response).to redirect_to(admin_projects_path)
      expect(flash[:notice]).to include('Project created')
    end

    it 'sucessful request - new image' do
      expect{ post('/admin/projects', params: new_image_upload_attributes) }.to change{
        ProjectImage.all.length
      }.from(0).to(1)
      expect(response).to redirect_to(admin_projects_path)
      expect(flash[:notice]).to include('Project created')
    end

    it 'save failure - project' do
      post('/admin/projects', params: invalid_attributes)
      expect(response.body).to include('Title cannot be empty')
    end

    it 'save failure - image' do
      allow(ProjectImage).to receive(:create).and_return(false)
      post('/admin/projects', params: new_image_upload_attributes)
      expect(response.body).to include('Image upload error')
      expect(Project.all.length).to eq(0)
      expect(ProjectImage.all.length).to eq(0)
    end

    it 'general error' do
      allow_any_instance_of(Project).to receive(:save).and_raise('general error')
      post('/admin/projects', params: valid_attributes)
      expect(response.body).to include('general error')
    end
  end

  describe 'GET /admin/project/:id/edit #edit' do
    it 'succesful request' do
      project = create(:project)
      get("/admin/projects/#{project.id}/edit")
      expect(response).to render_template(:edit)
    end

    it 'invalid id' do
      get('/admin/projects/not-a-project-id/edit')
      expect(response).to redirect_to(admin_projects_path)
      expect(flash[:alert]).to include('Project not found')
    end
  end

  describe 'PUT /admin/projects/:id #update' do
    it 'id invalid' do
      put('/admin/projects/not-a-project-id', params: valid_attributes)
      expect(response).to redirect_to(admin_projects_path)
      expect(flash[:alert]).to include('Project not found')
    end

    it 'sucessful request' do
      project = create(:project)
      put("/admin/projects/#{project.id}", params: valid_attributes)
      expect(response).to redirect_to(admin_projects_path)
      expect(flash[:notice]).to include('Project updated')
      project.reload
      expect(project.title).to eq(valid_attributes[:project][:title])
      expect(project.overview).to eq(valid_attributes[:project][:overview])
    end

    it 'sucessful - new image' do
      project = create(:project)
      expect{ put("/admin/projects/#{project.id}", params: new_image_upload_attributes) }.to change{
        project.reload.project_images.length
      }.by(1)
    end

    it 'sucessful request - update image title' do
      project = create(:project)
      project_image = project.project_images.create
      update_image_attributes = valid_attributes
      update_image_attributes[:project][:project_images_attributes] = [
        { title: 'new title', id: project_image.id }
      ]
      put("/admin/projects/#{project.id}", params: update_image_attributes)
      expect(project_image.reload.title).to eq('new title')
    end

    it 'sucessful request - remove image' do
      project = create(:project)
      project_image = project.project_images.create
      remove_image_attributes = valid_attributes
      remove_image_attributes[:project][:project_images_attributes] = [
        { _destroy: '1', id: project_image.id }
      ]
      expect{ put("/admin/projects/#{project.id}", params: remove_image_attributes) }.to change{
        project.reload.project_images.length
      }.from(1).to(0)
    end

    it 'sucessful request - add code snippet' do
      project = create(:project)
      code_snippet_attributes = valid_attributes
      code_snippet_attributes[:snippet] = {
        snippet: 'new code snippet',
        extension: 'rb'
      }
      expect_any_instance_of(Project).to receive(:render_code_snippet).with(code_snippet_attributes[:snippet]).and_return(true)
      put("/admin/projects/#{project.id}", params: code_snippet_attributes)
      expect(response).to redirect_to(admin_projects_path)
      expect(flash[:notice]).to include('Code snippet rendered')
    end

    it 'failed request - save failure' do
      project = create(:project)
      put("/admin/projects/#{project.id}", params: invalid_attributes)
      expect(response).not_to redirect_to(admin_projects_path)
      expect(response.body).to include('Title cannot be empty')
    end

    it 'failed request - invalid code snippet' do
      project = create(:project)
      code_snippet_attributes = valid_attributes
      code_snippet_attributes[:snippet] = {
        snippet: 'new code snippet',
        extension: 'not-A\n-extens|on.'
      }
      expect_any_instance_of(Project).to receive(:render_code_snippet).with(code_snippet_attributes[:snippet]).and_return(false)
      put("/admin/projects/#{project.id}", params: code_snippet_attributes)
      expect(response).not_to redirect_to(admin_projects_path)
      expect(response.body).to include('Code snippet invalid')
    end

    it 'failed request - general error' do
      project = create(:project)
      allow_any_instance_of(Project).to receive(:save).and_raise('general error')
      put("/admin/projects/#{project.id}", params: valid_attributes)
      expect(response).not_to redirect_to(admin_projects_path)
      expect(response.body).to include('general error')
    end
  end

  describe 'DELETE /admin/projects/:id #destroy' do
    it 'id invalid' do
      delete('/admin/projects/not-a-project-id')
      expect(response).to redirect_to(admin_projects_path)
      expect(flash[:alert]).to include('Project not found')
    end

    it 'successful request' do
      project = create(:project)
      expect{ delete("/admin/projects/#{project.id}") }.to change{
        Project.all.length
      }.from(1).to(0)
      expect(response).to redirect_to(admin_projects_path)
      expect(flash[:notice]).to include('Project removed')
    end

    it 'general error' do
      project = create(:project)
      allow_any_instance_of(Project).to receive(:destroy).and_raise('general error')
      delete("/admin/projects/#{project.id}")
      expect(response).to redirect_to(admin_projects_path)
      expect(flash[:alert]).to include('general error')
    end
  end
end
