require 'rails_helper'
require 'spec_helpers/session_helper'

RSpec.describe 'Request Admin:Images', type: :request do
  let(:image_path) { Rails.root.join('spec/files/sample_image.jpg') }
  let(:image_invalid_path) { Rails.root.join('spec/files/sample_image_invalid.jpg') }
  let(:image_fixture) { fixture_file_upload(image_path, 'image/png') }
  let(:image_fixture_invalid) { fixture_file_upload(image_invalid_path, 'image/png') }
  let(:image_file_error) { double :image_file, attach: false }
  let(:image_attach_error) do
    double :header_image, {
      image_file: image_file_error,
      errors: { error: 'Image attach error' },
      name: 'header_image',
      x_dim: 2560,
      y_dim: 300,
      assign_attributes: nil,
      attach_image: false,
      :x_loc= => 50,
      :y_loc= => 50,
      changed?: false
    }
  end

  before(:each) do
    login
  end

  describe 'GET /admin/images #index' do
    it 'Renders the index page' do
      get '/admin/images'
      expect(response).to render_template(:index)
    end
  end

  describe 'PUT /admin/header-images/:id #update' do
    context 'header-images' do
      it 'Update sucessful' do
        put "/admin/header-images/#{@header_image.id}", params: {
          header_image: {
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

      it 'Update unsucessful - invalid image id' do
        put "/admin/header-images/not-a-valid-id", params: {
          header_image: {
            update: image_fixture,
            x_loc: 50,
            y_loc: 50
          }
        }
        follow_redirect!
        expect(response.body).to include('Image not found')
        @header_image.reload
        expect(@header_image.image_file.attached?).to eq(false)
      end

      it 'Update unsucessful - general update error' do
        allow(HeaderImage).to receive(:find_by).and_raise('Image lookup error')
        put "/admin/header-images/#{@header_image.id}", params: {
          header_image: {
            update: image_fixture,
            x_loc: 50,
            y_loc: 50
          }
        }
        follow_redirect!
        expect(response.body).to include('Image lookup error')
        @header_image.reload
        expect(@header_image.image_file.attached?).to eq(false)
      end

      it 'Update unsucessful - invalid image' do
        put "/admin/header-images/#{@header_image.id}", params: {
          header_image: {
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
        allow(HeaderImage).to receive(:find_by).and_return(image_attach_error)
        put "/admin/header-images/#{@header_image.id}", params: {
          header_image: {
            update: image_fixture,
            x_loc: 50,
            y_loc: 50
          }
        }
        follow_redirect!
        expect(response.body).to include('Image attach error')
      end

      it 'Reset to default' do
        put "/admin/header-images/#{@header_image.id}", params: {
          header_image: {
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

    context 'cover-images' do
      it 'Update sucessful' do
        put "/admin/cover-images/#{@cover_image.id}", params: {
          cover_image: {
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

      it 'Update unsucessful - general update error' do
        allow(CoverImage).to receive(:find_by).and_raise('Image lookup error')
        put "/admin/cover-images/#{@cover_image.id}", params: {
          header_image: {
            update: image_fixture,
            x_loc: 50,
            y_loc: 50
          }
        }
        follow_redirect!
        expect(response.body).to include('Image lookup error')
        @cover_image.reload
        expect(@cover_image.image_file.attached?).to eq(false)
      end
    end
  end
end
