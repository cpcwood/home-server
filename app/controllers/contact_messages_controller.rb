class ContactMessagesController < ApplicationController
  def new
    @contact_message = ContactMessage.new
    @about = About.first
  end

  def create
    ContactMessage.create(permitted_params)
    redirect_to(contact_path, notice: 'Message sent! You should receive a confirmation email shortly.')
  end

  private

  def permitted_params
    params
      .require(:contact_message)
      .permit(
        :from,
        :email,
        :subject,
        :content)
  end
end