# == Schema Information
#
# Table name: code_snippet_images
#
#  id              :bigint           not null, primary key
#  description     :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  code_snippet_id :bigint           not null
#
# Indexes
#
#  index_code_snippet_images_on_code_snippet_id  (code_snippet_id)
#
# Foreign Keys
#
#  fk_rails_...  (code_snippet_id => code_snippets.id)
#
RSpec.describe CodeSnippetImage, type: :model do
  subject { create(:code_snippet_image) }

  describe 'before_validation' do
    describe '#set_defaults' do
      it 'no description' do
        code_snippet_image = create(:code_snippet_image, description: nil)
        expect(code_snippet_image.description).to eq('code-snippet-image')
      end
    end
  end
end
