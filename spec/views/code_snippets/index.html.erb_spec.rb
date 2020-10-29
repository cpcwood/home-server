describe 'Views' do
  let(:user) { build_stubbed(:user) }
  let(:code_snippet1) { build_stubbed(:code_snippet, user: user) }
  let(:code_snippet2) { build_stubbed(:code_snippet, user: user) }
  let(:code_snippets) { [code_snippet1, code_snippet2] }

  describe '/blog rendering' do
    it 'index view' do
      assign(:code_snippets, code_snippets)

      render template: 'code_snippets/index.html.erb'

      expect(rendered).to match(code_snippet1.title)
      expect(rendered).to match(code_snippet2.title)
      expect(rendered).to match(code_snippet1.overview)
      expect(rendered).to match(code_snippet2.overview)
      expect(rendered).not_to match('toolbar-container')
      expect(rendered).to match(code_snippet_path(code_snippet1))
      expect(rendered).to match(code_snippet_path(code_snippet2))
    end

    it 'user signed in' do
      assign(:code_snippets, code_snippets)
      assign(:user, user)

      render template: 'code_snippets/index.html.erb'
      expect(rendered).to match('toolbar-container')
    end

    it 'no code_snippets' do
      assign(:code_snippets, [])
      render template: 'code_snippets/index.html.erb'
      expect(rendered).to match('There are no code snippets here...')
    end
  end
end