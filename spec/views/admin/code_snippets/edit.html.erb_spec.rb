describe 'Views' do
  let(:code_snippet) { create(:code_snippet) }

  describe '/admin/code_snippets/:id/edit rendering' do
    context 'edit view' do
      before(:each) do
        assign(:code_snippet, code_snippet)
        render template: '/admin/code_snippets/edit.html.erb'
      end

      it 'it renders code_snippets' do
        expect(rendered).to match('code_snippet_title')
        expect(rendered).to match('code_snippet_overview')
        expect(rendered).to match('code_snippet_snippet')
        expect(rendered).to match('code_snippet_text')
        expect(rendered).to match(code_snippet.title)
        expect(rendered).to match(code_snippet.overview)
        expect(rendered).to match(code_snippet.text)
        expect(rendered).to match(admin_code_snippet_path(code_snippet))
        expect(rendered).to match(admin_code_snippets_path)
        expect(rendered).to match('Return')
        expect(rendered).to match('Remove')
      end
    end
  end
end