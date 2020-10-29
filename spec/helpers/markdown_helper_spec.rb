describe MarkdownHelper do
  describe '#markdown_admin' do
    let(:test_html) { '<h1>some html</h1>' }
    let(:redcarpet_mock) { double(:redcarpet, render: test_html) }
    let(:renderer_mock) { double(:html) }

    it 'renders markdown' do
      expect(Redcarpet::Render::HTML).to receive(:new).with(anything).and_return(renderer_mock)
      expect(Redcarpet::Markdown).to receive(:new).with(renderer_mock, anything).and_return(redcarpet_mock)
      helper.markdown_admin('test')
    end

    it 'markdown encapsulated in class' do
      allow(Redcarpet::Render::HTML).to receive(:new).and_return(renderer_mock)
      allow(Redcarpet::Markdown).to receive(:new).and_return(redcarpet_mock)
      expect(helper.markdown_admin('test')).to eq(%(<div class="markdown">#{test_html}</div>))
    end
  end

  describe '#markdown_code' do
    it 'encapsulates code' do
      code = 'some code'
      extension = 'rb'
      expect(helper).to receive(:markdown_admin).with("```#{extension}\n#{code}\n```").and_return('rendered markdown')
      expect(helper.markdown_code(code: code, extension: extension)).to eq('rendered markdown')
    end
  end
end