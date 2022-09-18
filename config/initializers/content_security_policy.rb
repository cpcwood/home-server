# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

if Rails.env.production?
  Rails.application.configure do
    config.content_security_policy do |policy|
      policy.default_src :self
      policy.font_src    :self, :data
      policy.img_src     :self, :data, "https://#{ENV.fetch('AWS_BUCKET', '')}.s3.#{ENV.fetch('AWS_REGION', '')}.amazonaws.com", 'https://img.shields.io'
      policy.media_src   :self, :data, "https://#{ENV.fetch('AWS_BUCKET', '')}.s3.#{ENV.fetch('AWS_REGION', '')}.amazonaws.com"
      policy.object_src  :none
      policy.base_uri    :self
      policy.script_src  :self, :unsafe_eval, :unsafe_inline, 'https://www.google.com/recaptcha/api.js', 'https://www.gstatic.com/recaptcha'
      policy.style_src   :self, :unsafe_inline
      policy.connect_src :self 
      # Specify URI for violation reports
      # policy.report_uri "/csp-violation-report-endpoint"
    end

    # Generate session nonces for permitted importmap and inline scripts
    config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
    config.content_security_policy_nonce_directives = %w(script-src)

    # Report violations without enforcing the policy.
    # config.content_security_policy_report_only = true
  end
end
