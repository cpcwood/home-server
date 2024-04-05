describe 'Views' do
  let(:contact_message) { build(:contact_message) }
  let(:about) { build(:about) }

  describe '/contact rendering' do
    context 'new view' do
      before(:each) do
        assign(:contact_message, contact_message)
        assign(:about, about)
        render template: '/contact_messages/new'
      end

      it 'it renders form' do
        expect(rendered).to match('contact_message_from')
        expect(rendered).to match('contact_message_subject')
        expect(rendered).to match('contact_message_email')
        expect(rendered).to match('contact_message_content')
        expect(rendered).to match(contact_messages_path)
      end
    end
  end
end
