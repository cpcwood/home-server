RSpec.describe 'AdminProjects', type: :request do
  let(:valid_attributes) do
    { project: {
      title: 'new code snippet',
      overview: 'code snippet overview',
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
      overview: 'code snippet overview',
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
end
