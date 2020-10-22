RSpec.describe ProcessImageVariantJob, type: :job do
  let(:image_file_upload) { fixture_file_upload(Rails.root.join('spec/files/sample_image.jpg'), 'image/jpg') }
  let(:image) { create(:gallery_image, image_file: image_file_upload) }

  before(:each) do
    allow_any_instance_of(Image).to receive(:process_new_image_attachment).and_return(true)
  end

  it 'Password reset email sent' do
    variant_details = { resize_to_limit: [100, 100] }
    mock_variant = double(:variant, processed: nil)
    expect(image.image_file).to receive(:variant).with(variant_details).and_return(mock_variant)
    expect(mock_variant).to receive(:processed)
    ProcessImageVariantJob.perform_now(model: image, variant: variant_details)
  end
end