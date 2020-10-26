class ContactMessageMailer < ApplicationMailer
  include AttachmentHelper

  default from: Rails.application.credentials.email[:no_reply_email]

  def contact_message
    assign_default_variables
    mail(to: params[:deliver_to], reply_to: @from_email, subject: "New contact message: #{@subject}") do |format|
      format.html { render layout: 'default_email' }
    end
  end

  def confirmation
    assign_default_variables
    mail(to: @from_email, subject: "Contact message sent: #{@subject}") do |format|
      format.html { render layout: 'default_email' }
    end
  end

  private

  def assign_default_variables
    contact_message = params[:contact_message]
    @user = contact_message.user
    @from_name = contact_message.from
    @from_email = contact_message.email
    @subject = contact_message.subject
    @content = contact_message.content
    header_image = SiteSetting.first.header_image
    @header_image_url = if header_image.image_file.attached?
                          Rails.application.routes.url_helpers.rails_blob_path(header_image.image_file)
                        else
                          image_path_helper(image_model: header_image)
                        end
  end
end
