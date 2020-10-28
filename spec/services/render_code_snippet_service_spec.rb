describe RenderCodeSnippetService do
  let(:config_path) { Rails.root.join('config/carbon-config.json') }

  describe '.render' do
    it 'default config' do
      snippet_text = 'test text'
      extension = 'rb'
      rails_root_mock = double(:rails, join: 'config-path.json')
      attachment_mock = double(:attachment)
      tmp_code_file_mock = double(:tempfile, path: 'code-file-path-test', close: nil)
      tmp_image_file_mock = double(:tempfile, path: 'img-file-path-test', close: nil)
      io_mock = double(:io, close: nil)

      allow(Rails).to receive(:root).and_return(rails_root_mock)
      allow(Tempfile).to receive(:new).with('code-snippet-image').and_return(tmp_image_file_mock)
      allow(Tempfile).to receive(:new).with([RenderCodeSnippetService::Renderer::DEFAULT_FILENAME, ".#{extension}"]).and_return(tmp_code_file_mock)
      allow(File).to receive(:dirname).with('img-file-path-test').and_return('img-file-dir')
      allow(File).to receive(:basename).with('img-file-path-test').and_return('img-file-name')
      allow(File).to receive(:open).with('img-file-path-test.png').and_return('img-file')

      expect(tmp_code_file_mock).to receive(:write).with(snippet_text)
      expect(IO).to receive(:popen).with('carbon-now code-file-path-test -l img-file-dir -t img-file-name --headless --config config-path.json -p default', 'w+').and_return(io_mock)
      expect(attachment_mock).to receive(:attach).with(io: 'img-file', filename: "#{RenderCodeSnippetService::Renderer::DEFAULT_FILENAME}.png", content_type: 'image/png')
      expect(tmp_code_file_mock).to receive(:unlink)
      expect(tmp_image_file_mock).to receive(:unlink)

      RenderCodeSnippetService.render_and_attach_image(snippet_text: snippet_text, syntax_extension: extension, attachment: attachment_mock)
    end
  end
end