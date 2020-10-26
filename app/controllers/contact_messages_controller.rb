class ContactMessagesController < ApplicationController
  def new
    @contact_message = ContactMessage.new
    @about = About.first
  end
end