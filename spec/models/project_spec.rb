# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  date          :datetime         not null
#  extension     :string
#  github_link   :string
#  overview      :text
#  site_link     :string
#  snippet       :text
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  main_image_id :bigint
#
# Indexes
#
#  index_projects_on_main_image_id  (main_image_id)
#
# Foreign Keys
#
#  fk_rails_...  (main_image_id => project_images.id)
#

RSpec.describe Project, type: :model do
  subject { build_stubbed(:project) }

  describe 'validation' do
    describe 'title' do
      it 'format' do
        subject.title = nil
        expect(subject).to_not be_valid
        subject.title = ''
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:title]).to eq ['Title cannot be empty']
        subject.title = 'a'
        expect(subject).to be_valid
      end
    end

    describe 'date' do
      it 'format' do
        subject.date = nil
        expect(subject).to_not be_valid
        subject.date = 'not a date'
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:date]).to eq ['Date format invalid']
        subject.date = DateTime.new(2020, 04, 19, 0, 0, 0)
        expect(subject).to be_valid
      end
    end

    describe 'extension' do
      it 'format' do
        subject.extension = '.a'
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:extension]).to eq ['File extension invalid']
        subject.extension = nil
        expect(subject).to be_valid
        subject.extension = ''
        expect(subject).to be_valid
        subject.extension = 'a'
        expect(subject).to be_valid
      end
    end

    describe 'github_link' do
      it 'is link' do
        subject.github_link = 'not a link'
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:github_link]).to eq ['Github link is not valid']
        subject.github_link = ''
        expect(subject).to be_valid
      end
    end

    describe 'site_link' do
      it 'is link' do
        subject.site_link = 'not a link'
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:site_link]).to eq ['Site link is not valid']
        subject.site_link = ''
        expect(subject).to be_valid
      end
    end
  end
end
