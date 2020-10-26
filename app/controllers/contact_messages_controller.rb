class ContactMessagesController < ApplicationController
  def new
    @contact_message = ContactMessage.new
    @about = About.first
  end

  def create
    @notices = []
    @alerts = []
    begin
      @contact_message = ContactMessage.new
      update_model(model: @contact_message, success_message: 'Message sent! You should receive a confirmation email shortly.')
    rescue StandardError => e
      logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
      @alerts.push('Sorry, something went wrong!')
    end
    if @alerts.any?
      flash[:alert] = @alerts
      render(
        partial: 'partials/form_replacement',
        locals: {
          selector_id: 'contact-messages-new-form',
          form_partial: 'contact_messages/new_form',
          model: { contact_message: @contact_message }
        },
        formats: [:js])
      flash[:alert] = nil
    else
      redirect_to(contact_path, notice: @notices)
    end
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

  def update_model(model:, success_message:)
    if model.update(permitted_params)
      @notices.push(success_message)
    else
      @alerts.push(model.errors.values.flatten.last)
    end
  end
end