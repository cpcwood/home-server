require 'rails_helper'
require 'spec_helpers/session_helper'

RSpec.describe 'Images', type: :request do
  let(:image_path) { Rails.root.join('spec/files/sample_image.jpg') }
  let(:image_invalid_path) { Rails.root.join('spec/files/sample_image_invalid.jpg') }
  let(:image_fixture) { fixture_file_upload(image_path, 'image/png') }
  let(:image_fixture_invalid) { fixture_file_upload(image_invalid_path, 'image/png') }
  let(:image_file_error) { double :image_file, attach: false }
  let(:image_attach_error) { double :image, image_file: image_file_error, errors: { error: 'Image attach error' }, name: 'header_image', x_dim: 2560, y_dim: 300, update: nil }

  before(:each) do
    login
  end

  describe 'GET /admin/images #index' do
    it 'Renders the index page' do
      get '/admin/images'
      expect(response).to render_template(:index)
    end
  end

  describe 'PUT /admin/images/:id #update' do
    context 'header_image' do
      it 'Update sucessful' do
        put "/admin/images/#{@header_image.id}", params: {
          image: {
            update: image_fixture,
            x_loc: 10,
            y_loc: 15
          }
        }
        follow_redirect!
        expect(response.body).to include('Header image updated!')
        @header_image.reload
        expect(@header_image.image_file.attached?).to eq(true)
        expect(@header_image.x_loc).to eq(10)
        expect(@header_image.y_loc).to eq(15)
      end

      it 'Update unsucessful - invalid image' do
        put "/admin/images/#{@header_image.id}", params: {
          image: {
            update: image_fixture_invalid,
            x_loc: 50,
            y_loc: 50
          }
        }
        follow_redirect!
        expect(response.body).to include('Header image invalid, please upload a jpeg or png file!')
        @header_image.reload
        expect(@header_image.image_file.attached?).to eq(false)
      end

      it 'Update unsucessful - save error' do
        allow(Image).to receive(:find_by).and_return(image_attach_error)
        put "/admin/images/#{@header_image.id}", params: {
          image: {
            update: image_fixture,
            x_loc: 50,
            y_loc: 50
          }
        }
        follow_redirect!
        expect(response.body).to include('Image attach error')
      end

      it 'Reset to default' do
        put "/admin/images/#{@header_image.id}", params: {
          image: {
            update: image_fixture,
            reset: '1',
            x_loc: 50,
            y_loc: 50
          }
        }
        follow_redirect!
        expect(response.body).to include('Header image reset!')
        @header_image.reload
        expect(@header_image.image_file.attached?).to eq(false)
      end
    end

    context 'cover_image' do
      it 'Update sucessful' do
        put "/admin/images/#{@cover_image.id}", params: {
          image: {
            update: image_fixture,
            x_loc: 50,
            y_loc: 50
          }
        }
        follow_redirect!
        expect(response.body).to include('Cover image updated!')
        @cover_image.reload
        expect(@cover_image.image_file.attached?).to eq(true)
      end
    end
  end
end
