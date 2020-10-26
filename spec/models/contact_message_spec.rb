# == Schema Information
#
# Table name: contact_messages
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  email      :string           not null
#  from       :string           not null
#  subject    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_contact_messages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

RSpec.describe ContactMessage, type: :model do
  subject { build_stubbed(:contact_message) }

  describe 'validations' do
    describe 'from' do
      it 'format' do
        subject.from = nil
        expect(subject).to_not be_valid
        subject.from = ''
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:from]).to eq(['From field cannot be blank'])
        subject.from = 'a'
        expect(subject).to be_valid
      end
    end

    describe 'email' do
      it 'format' do
        subject.email = nil
        expect(subject).to_not be_valid
        subject.email = 'test@'
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:email]).to eq(['Email must be valid'])
        subject.email = 'test@example.com'
        expect(subject).to be_valid
      end
    end

    describe 'subject' do
      it 'format' do
        subject.subject = nil
        expect(subject).to_not be_valid
        subject.subject = ''
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:subject]).to eq(['Subject cannot be blank'])
        subject.subject = 'a'
        expect(subject).to be_valid
      end
    end

    describe 'content' do
      it 'format' do
        subject.content = nil
        expect(subject).to_not be_valid
        subject.content = ''
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:content]).to eq(['Content cannot be blank'])
        subject.content = 'a'
        expect(subject).to be_valid
      end
    end
  end

  describe 'after_commit' do
    describe '#send_contact_message' do
      it 'generates new job' do
        user = create(:user)
        message = build(:contact_message, user: user)
        expect(NewContactMessageJob).to receive(:perform_later).with(message: message, user: user)
        message.save
      end
    end
  end
end
