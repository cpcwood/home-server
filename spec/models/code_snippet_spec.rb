# == Schema Information
#
# Table name: code_snippets
#
#  id         :bigint           not null, primary key
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
  end
end
