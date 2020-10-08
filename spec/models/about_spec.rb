require 'rails_helper'

RSpec.describe About, type: :model do
  describe '#change_messages' do
    it 'no changes' do
      about = About.create
      about.reload
      expect(about.change_messages).to eq([])
    end

    it 'attribute changes' do
      about = About.create
      about.update(name: 'new name', about_me: 'new description')
      expect(about.change_messages).to eq(["About name updated!", "About about me updated!"])
    end
  end
end
