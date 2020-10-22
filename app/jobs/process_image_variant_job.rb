class ProcessImageVariantJob < ApplicationJob
  queue_as :default

  def perform(image_attachment:, variant:)
    image_attachment.variant(variant).processed
  end
end
