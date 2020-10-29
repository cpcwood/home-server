# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  date        :datetime         not null
#  github_link :string
#  overview    :text
#  site_link   :string
#  snippet     :text
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

RSpec.describe Project, type: :model do

  subject { build_stubbed(:project) }

  describe 'validation' do
    describe 'title' do
      it 'presence' do
        subject.title = nil
        expect(subject).to_not be_valid
        subject.title = ''
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:title]).to eq ['Title cannot be empty']
        subject.title = 'a'
        expect(subject).to be_valid
      end
    end
  end
end
