# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  date_published :datetime         not null
#  overview       :string           not null
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  subject { create(:post) }

  context 'validations' do
    describe 'date_published' do
      it 'format' do
        subject.date_published = nil
        expect(subject).to_not be_valid
        subject.date_published = 'not a date'
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:date_published]).to eq ['Date published must be date']
      end
    end

    describe 'overview' do
      it 'format' do
        subject.overview = nil
        expect(subject).to_not be_valid
        subject.overview = ''
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:overview]).to eq ['Blog post overview cannot be empty']
      end
    end

    describe 'title' do
      it 'format' do
        subject.title = nil
        expect(subject).to_not be_valid
        subject.title = ''
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:title]).to eq ['Blog post title cannot be empty']
      end
    end

    describe 'user associtation' do
      it 'presence' do
        subject.user = nil
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'to_param' do
    it 'human title' do
      post = create(:post)
      expect(post.to_param).to eq("#{post.id}-#{post.title.parameterize}")
    end
  end
end
