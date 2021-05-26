class ContactMessageMailer < ApplicationMailer
  include AttachmentHelper
  include DateHelper

  default from: Rails.configuration.email_no_reply_address

  def contact_message
    assign_default_variables
    @to_email = @about.contact_email
    @to_name = @about.name
    @from_name = @contact_message.from
    @from_email = @contact_message.email
    mail(to: @to_email, reply_to: @from_email, subject: "New contact message: #{@subject}") do |format|
      format.html { render layout: 'default_email' }
    end
  end

  def confirmation
    assign_default_variables
    @to_email = @contact_message.email
    @to_name = @contact_message.from
    @user_name = @about.name
    mail(to: @to_email, subject: "Contact message sent: #{@subject}") do |format|
      format.html { render layout: 'default_email' }
    end
  end

  private

  def assign_default_variables
    @about = About.first
    @contact_message = params[:contact_message]
    @user = @contact_message.user
    @subject = @contact_message.subject
    @content = @contact_message.content
    @datetime = full_date_and_time(@contact_message.created_at)
    header_image = SiteSetting.first.header_image
    @header_image_url = if header_image.image_file.attached?
                          Rails.application.routes.url_helpers.rails_blob_path(header_image.image_file)
                        else
                          image_path_helper(image_model: header_image)
                        end
  end
end
