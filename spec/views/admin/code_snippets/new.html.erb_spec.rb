describe 'Views' do
  let(:code_snippet) { build(:code_snippet) }

  describe '/admin/code-snippets/new rendering' do
    context 'new view' do
      before(:each) do
        assign(:code_snippet, code_snippet)
        render template: '/admin/code_snippets/new'
      end

      it 'it renders code_snippets' do
        expect(rendered).to match('code_snippet_title')
        expect(rendered).to match('code_snippet_overview')
        expect(rendered).to match('code_snippet_snippet')
        expect(rendered).to match('code_snippet_extension')
        expect(rendered).to match('code_snippet_text')
      end
    end
  end
end