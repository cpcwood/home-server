RSpec.describe 'AdminProjects', type: :request do
  let(:valid_attributes) do
    { project: {
      title: 'new project',
      overview: 'project overview',
      date: DateTime.new(2020, 04, 19, 0, 0, 0),
      github_link: 'https://example.com/github',
      site_link: 'https://example.com/site',
      snippet: '',
      extension: ''
    }}
  end

  let(:invalid_attributes) do
    { project: {
      title: '',
      overview: 'project overview',
      date: DateTime.new(2020, 04, 19, 0, 0, 0),
      github_link: 'https://example.com/github',
      site_link: 'https://example.com/site',
      snippet: '',
      extension: ''
    }}
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
      }.by(1)
      expect(response).to redirect_to(admin_projects_path)
      expect(flash[:notice]).to include('Project created')
    end

    it 'save failure' do
      post('/admin/projects', params: invalid_attributes)
      expect(response.body).to include('Title cannot be empty')
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

    it 'update sucessful' do
      project = create(:project)
      put("/admin/projects/#{project.id}", params: valid_attributes)
      expect(response).to redirect_to(admin_projects_path)
      expect(flash[:notice]).to include('Project updated')
      project.reload
      expect(project.title).to eq(valid_attributes[:project][:title])
      expect(project.overview).to eq(valid_attributes[:project][:overview])
    end

    it 'save failure' do
      project = create(:project)
      put("/admin/projects/#{project.id}", params: invalid_attributes)
      expect(response).not_to redirect_to(admin_projects_path)
      expect(response.body).to include('Title cannot be empty')
    end

    it 'general error' do
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
