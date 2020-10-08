require 'rails_helper'

RSpec.describe About, type: :model do
  describe '#change_messages' do
    before(:each) do
      @about = About.create
    end

    it 'no changes' do
      expect(@about.change_messages).to eq([])
    end
  end
end
