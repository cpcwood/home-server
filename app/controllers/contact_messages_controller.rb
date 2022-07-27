class ContactMessagesController < ApplicationController
  def new
    @contact_message = ContactMessage.new
    @about = About.first
  end

  def create
    @notices = []
    flash[:alert] = []

    begin
      create_message!
    rescue StandardError => e
      logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
      flash[:alert].push('Sorry, something went wrong!')
    end

    if flash[:alert].any?
      render(partial: 'contact_messages/new_form', 
             status: :unprocessable_entity, 
             locals: {
               contact_message: @contact_message
             })
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

  def create_message!
    @contact_message = User.first.contact_messages.new(permitted_params)
    return unless recaptcha_valid?

    if @contact_message.save
      @notices.push('Message sent! You should receive a confirmation email shortly.')
    else
      flash[:alert].push(@contact_message.errors.messages.to_a.flatten.last)
    end
  end

  def recaptcha_valid?
    return true if ReCaptchaService.recaptcha_valid?(params['g-recaptcha-response'])
    flash[:alert].push('reCaptcha failed, please try again')
    false
  end
end