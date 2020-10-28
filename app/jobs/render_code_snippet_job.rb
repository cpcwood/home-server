class RenderCodeSnippetJob < ApplicationJob
  require 'tempfile'

  queue_as :default

  def perform(code_snippet:)
    # load config
    config_path = Rails.root.join('config/carbon-config.json')
    start_line = 0
    end_line = 12

    # create temp text file
    code_file = Tempfile.new([code_snippet.title.parameterize, ".#{code_snippet.extension}"])
    code_file.write(code_snippet.snippet)
    code_file.rewind

    # create tmp image file params
    temp_imagefile_dir = Rails.root.join('tmp')
    temp_imagefile_name = SecureRandom.urlsafe_base64
    tmp_imagefile_path = Rails.root.join('tmp', "#{temp_imagefile_name}.png")

    # generate image
    io = IO.popen("carbon-now #{code_file.path} -l #{temp_imagefile_dir} -t #{temp_imagefile_name} -s #{start_line} -e #{end_line} --headless --config #{config_path} -p default", 'w+')
    io.close

    # attach image
    code_snippet_image = code_snippet.create_code_snippet_image
    code_snippet_image.image_file.attach(
      io: File.open(tmp_imagefile_path),
      filename: 'code-snippet-image.png',
      content_type: 'image/png')

    # remove temp files
    code_file.close
    code_file.unlink
    File.delete(tmp_imagefile_path)
  end
end