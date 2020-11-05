# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  date        :datetime         not null
#  github_link :string
#  overview    :text
#  site_link   :string
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

RSpec.describe Project, type: :model do
  subject { create(:project) }

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

  describe '#render_code_snippet' do
    describe 'validations' do
      describe 'snippet' do
        it 'type' do
          expect(subject.render_code_snippet(snippet: 1, extension: 'rb')).to be(false)
          expect(subject.render_code_snippet(snippet: 'string', extension: 'rb')).to be(true)
        end

        it 'format' do
          expect(subject.render_code_snippet(snippet: '', extension: 'rb')).to be(false)
          expect(subject.render_code_snippet(snippet: 'a', extension: 'rb')).to be(true)
        end
      end

      describe 'extension' do
        it 'type' do
          expect(subject.render_code_snippet(snippet: 'code', extension: 1)).to be(false)
          expect(subject.render_code_snippet(snippet: 'code', extension: 'string')).to be(true)
        end

        it 'format' do
          expect(subject.render_code_snippet(snippet: 'code', extension: '.rb')).to be(false)
          expect(subject.render_code_snippet(snippet: 'code', extension: 'rb')).to be(true)
        end
      end
    end

    it 'valid inputs' do
      project = create(:project)
      mock_project_image = create(:project_image, project: project)
      mock_collection = double(:collection, create: mock_project_image)
      allow(project).to receive(:project_images).and_return(mock_collection)
      project.render_code_snippet(snippet: 'code', extension: 'rb')
      expect(RenderCodeSnippetJob).to have_been_enqueued.with(model: mock_project_image, snippet: 'code', extension: 'rb')
    end
  end
end
