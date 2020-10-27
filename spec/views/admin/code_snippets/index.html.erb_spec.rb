describe 'Views' do
  let(:user) { build_stubbed(:user) }
  let(:code_snippet1) { build_stubbed(:code_snippet, user: user) }
  let(:code_snippet2) { build_stubbed(:code_snippet, user: user) }
  let(:code_snippets) { [code_snippet1, code_snippet2] }

  describe '/admin/blog rendering' do
    before(:each) do
      allow_any_instance_of(AdminLinkHelper).to receive(:in_admin_scope?).and_return(true)
    end

    context 'index view' do
      before(:each) do
        assign(:code_snippets, code_snippets)
        assign(:user, user)
        render template: 'admin/code_snippets/index.html.erb'
      end

      it 'it renders code_snippets' do
        expect(rendered).to match(code_snippet1.title)
        expect(rendered).to match(code_snippet2.title)
        expect(rendered).to match(code_snippet1.overview)
        expect(rendered).to match(code_snippet2.overview)
        expect(rendered).to match('toolbar-container')
        expect(rendered).to match(edit_admin_code_snippet_path(code_snippet1))
        expect(rendered).to match(edit_admin_code_snippet_path(code_snippet2))
      end

      it 'no code_snippets' do
        assign(:code_snippets, [])
        assign(:user, user)
        render template: 'admin/code_snippets/index.html.erb'
        expect(rendered).to match('There are no code snippets here...')
      end
    end
  end
end