describe 'Views' do
  let(:project1) { build_stubbed(:project) }
  let(:project2) { build_stubbed(:project) }
  let(:projects) { [project1, project2] }

  describe '/projects rendering' do
    it 'no projects' do
      assign(:projects, [])
      render template: 'projects/index.html.erb'
      expect(rendered).to match('There are no projects here...')
    end
  end
end