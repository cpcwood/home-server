RSpec.describe RenderCodeSnippetJob, type: :job do
  let(:code_snippet) { build_stubbed(:code_snippet) }

  it 'code snippet image rendered and attached' do
    mock_attachment = double(:attachment)
    mock_code_snippet_image = double(:code_snippet_image, image_file: mock_attachment)
    allow(code_snippet).to receive(:create_code_snippet_image).and_return(mock_code_snippet_image)

    expect(RenderCodeSnippetService).to receive(:render_and_attach_image)
      .with(
        snippet_text: code_snippet.snippet,
        syntax_extension: code_snippet.extension,
        attachment: mock_attachment,
        start_line: 0,
        end_line: 12)

    RenderCodeSnippetJob.perform_now(model: code_snippet.create_code_snippet_image, snippet: code_snippet.snippet, extension: code_snippet.extension)
  end
end