class ProcessImageVariantJob < ApplicationJob
  queue_as :default

  def perform(model:, variant:)
    model.image_file.variant(variant).processed
  end
end
