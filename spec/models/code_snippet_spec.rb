# == Schema Information
#
# Table name: code_snippets
#
#  id         :bigint           not null, primary key
#  extension  :string           not null
#  overview   :string           not null
#  snippet    :text             not null
#  text       :text
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_code_snippets_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
RSpec.describe CodeSnippet, type: :model do
  subject { build_stubbed(:code_snippet) }

  describe 'validations' do
    describe 'title' do
      it 'format' do
        subject.title = nil
        expect(subject).to_not be_valid
        subject.title = ''
        expect(subject).to_not be_valid
        subject.title = 'a' * 51
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:title]).to eq ['Title length must be between 1 and 50 charaters']
        subject.title = 'a'
        expect(subject).to be_valid
        subject.title = 'a' * 50
        expect(subject).to be_valid
      end
    end

    describe 'overview' do
      it 'format' do
        subject.overview = nil
        expect(subject).to_not be_valid
        subject.overview = ''
        expect(subject).to_not be_valid
        subject.overview = 'a' * 161
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:overview]).to eq ['Overview length must be between 1 and 160 charaters']
        subject.overview = 'a'
        expect(subject).to be_valid
        subject.overview = 'a' * 160
        expect(subject).to be_valid
      end
    end

    describe 'snippet' do
      it 'format' do
        subject.snippet = nil
        expect(subject).to_not be_valid
        subject.snippet = ''
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:snippet]).to eq ['Code snippet cannot be blank']
        subject.snippet = 'a'
        expect(subject).to be_valid
      end
    end

    describe 'extension' do
      it 'format' do
        subject.extension = nil
        expect(subject).to_not be_valid
        subject.extension = ''
        expect(subject).to_not be_valid
        subject.extension = '.a'
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:extension]).to eq ['Code must be valid file extension']
        subject.extension = 'a'
        expect(subject).to be_valid
      end
    end
  end

  describe 'after_commit' do
    describe '#render_snippet_image' do
      it 'after model commited' do
        code_snippet = build(:code_snippet)
        code_snippet.save
        expect(RenderCodeSnippetJob).to have_been_enqueued.with(model: code_snippet, text: code_snippet.text, extension: code_snippet.extension)
      end
    end
  end
end
