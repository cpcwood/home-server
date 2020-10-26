describe 'Views' do
  let(:contact_message) { build(:contact_message) }
  let(:about) { build(:about) }

  describe '/contact rendering' do
    context 'new view' do
      before(:each) do
        assign(:contact_message, contact_message)
        assign(:about, about)
        render template: '/contact_messages/new.html.erb'
      end

      it 'it renders form' do
        expect(rendered).to match('contact_message_from')
        expect(rendered).to match('contact_message_subject')
        expect(rendered).to match('contact_message_email')
        expect(rendered).to match('contact_message_content')
        expect(rendered).to match(contact_messages_path)
      end

      it 'it renders about details' do
        expect(rendered).to match(about.name)
        expect(rendered).to match(about.location)
      end
    end
  end
end