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
      return unless recaptcha_valid?
      update_model(model: @contact_message, success_message: 'Message sent! You should receive a confirmation email shortly.')
    rescue StandardError => e
      logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
      @alerts.push('Sorry, something went wrong!')
    end
    if @alerts.any?
      render_form_alerts
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

  def recaptcha_valid?
    return true if ReCaptchaService.recaptcha_valid?(params['g-recaptcha-response'])
    @alerts.push('reCaptcha failed, please try again')
    @contact_message.assign_attributes(permitted_params)
    render_form_alerts
    false
  end

  def update_model(model:, success_message:)
    if model.update(permitted_params)
      @notices.push(success_message)
    else
      @alerts.push(model.errors.values.flatten.last)
    end
  end

  def render_form_alerts
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
  end
end