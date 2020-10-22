RSpec.describe SiteImage, type: :model do

  subject { create(:cover_image) }
  let(:image_jpg_path) { Rails.root.join('spec/files/sample_image.jpg') }
  let(:image_file_upload) { fixture_file_upload(image_jpg_path, 'image/jpg') }

  describe 'validations' do
    describe 'x_loc' do
      it 'presence' do
        subject.x_loc = nil
        expect(subject).to_not be_valid
      end
    
      it 'format' do
        subject.x_loc = -1
        expect(subject).to_not be_valid
        subject.x_loc = 0
        expect(subject).to be_valid
        subject.x_loc = 101
        expect(subject).to_not be_valid
        subject.x_loc = 100
        expect(subject).to be_valid
      end
    end
    
    describe 'y_loc' do
      it 'presence' do
        subject.y_loc = nil
        expect(subject).to_not be_valid
      end
    
      it 'format' do
        subject.y_loc = -1
        expect(subject).to_not be_valid
        subject.y_loc = 0
        expect(subject).to be_valid
        subject.y_loc = 101
        expect(subject).to_not be_valid
        subject.y_loc = 100
        expect(subject).to be_valid
      end
    end
  end

  describe '#custom_style' do
    it 'locations are default' do
      expect(subject.custom_style).to eq(nil)
    end
  
    it 'x_loc custom' do
      subject.update(x_loc: 10)
      expect(subject.custom_style).to eq('object-position: 10% 50%;')
    end
  
    it 'y_loc custom' do
      subject.update(y_loc: 10)
      expect(subject.custom_style).to eq('object-position: 50% 10%;')
    end
  
    it 'x_loc and y_loc custom' do
      subject.update(x_loc: 10, y_loc: 90)
      expect(subject.custom_style).to eq('object-position: 10% 90%;')
    end
  end

  describe '#reset_to_default' do
    it 'file purged' do
      expect(subject.image_file).to receive(:purge_later)
      subject.reset_to_default
    end

    it 'locations reset' do
      subject.x_loc = 40
      subject.y_loc = 60
      subject.save
      subject.reset_to_default
      expect(subject.x_loc).to eq(SiteImage::DEFAULT_X_LOC)
      expect(subject.y_loc).to eq(SiteImage::DEFAULT_Y_LOC)
    end
  end
end
