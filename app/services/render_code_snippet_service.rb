module RenderCodeSnippetService
  def self.render_and_attach_image(snippet_text:, syntax_extension:, attachment:)
    renderer = Renderer.new(snippet_text: snippet_text, syntax_extension: syntax_extension, attachment: attachment)
    renderer.perform!
  end

  class Renderer
    require 'tempfile'

    DEFAULT_FILENAME = 'code-snippet'.freeze

    def initialize(snippet_text:, syntax_extension:, attachment:)
      @config_path = Rails.root.join('config/carbon-config.json')
      @text = snippet_text
      @extension = syntax_extension.match?(/\A\.[A-Za-z0-9]\z/) ? syntax_extension : ".#{syntax_extension}"
      @attachment = attachment
      @filename = DEFAULT_FILENAME
    end

    def perform!
      generate_temp_files
      generate_image
      attach_image
      cleanup
    end

    private

    def generate_temp_files
      @tmp_img_file = Tempfile.new('code-snippet-image')
      @tmp_code_file = Tempfile.new([@filename, @extension])
      @tmp_code_file.write(@text)
      @tmp_img_file.close
      @tmp_img_file.close
    end

    def generate_image
      io = IO.popen("carbon-now #{@tmp_code_file.path} -l #{File.dirname(@tmp_img_file.path)} -t #{File.basename(@tmp_img_file.path)} --headless --config #{@config_path} -p default", 'w+')
      io.close
    end

    def attach_image
      @attachment.attach(
        io: File.open("#{@tmp_img_file.path}.png"),
        filename: "#{@filename}.png",
        content_type: 'image/png')
    end

    def cleanup
      @tmp_code_file.unlink
      @tmp_img_file.unlink
    end
  end
end