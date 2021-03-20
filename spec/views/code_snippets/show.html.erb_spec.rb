describe 'Views' do
  let(:user) { build_stubbed(:user) }
  let(:code_snippet) { build_stubbed(:code_snippet, user: user) }

  describe '/code-snippets/:id rendering' do
    it 'show view' do
      assign(:code_snippet, code_snippet)
      expect_any_instance_of(MarkdownHelper).to receive(:markdown_admin).with(code_snippet.text).and_return('some markdown')
      expect_any_instance_of(MarkdownHelper).to receive(:markdown_code).with(code: code_snippet.snippet, extension: code_snippet.extension).and_return('highlighted snippet')
      expect_any_instance_of(DateHelper).to receive(:full_date).with(code_snippet.updated_at).and_return('updated_date')

      render template: 'code_snippets/show'

      expect(rendered).to match(code_snippet.title)
      expect(rendered).to match(user.username)
      expect(rendered).to match('some markdown')
      expect(rendered).to match('highlighted snippet')
      expect(rendered).to match('updated_date')
      expect(rendered).to match(code_snippets_path)
    end
  end
end