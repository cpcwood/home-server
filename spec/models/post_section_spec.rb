# == Schema Information
#
# Table name: post_sections
#
#  id         :bigint           not null, primary key
#  order      :integer          default(0), not null
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
RSpec.describe PostSection, type: :model do
  subject { create(:post_section) }

  context 'validations' do
    describe 'order' do
      it 'presence' do
        subject.order = nil
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:order].first).to eq('Post Section order cannot be nil')
        subject.order = 1
        expect(subject).to be_valid
      end
    end
  end
end
