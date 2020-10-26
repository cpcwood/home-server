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
  end
end
