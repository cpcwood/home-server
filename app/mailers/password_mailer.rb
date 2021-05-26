class PasswordMailer < ApplicationMailer
  include AttachmentHelper

  default from: Rails.configuration.email_no_reply_address

  def password_reset_email
    assign_default_variables
    mail(to: @user.email, subject: "Password Reset: #{@user.email}") do |format|
      format.html { render layout: 'default_email' }
    end
  end

  def password_updated_email
    assign_default_variables
    mail(to: @user.email, subject: "Your Password Has Been Updated: #{@user.email}") do |format|
      format.html { render layout: 'default_email' }
    end
  end

  private

  def assign_default_variables
    @user = params[:user]
    header_image = SiteSetting.first.header_image
    @header_image_url = if header_image.image_file.attached?
                          Rails.application.routes.url_helpers.rails_blob_path(header_image.image_file)
                        else
                          image_path_helper(image_model: header_image)
                        end
  end
end
