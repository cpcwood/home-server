class RemoveAboutToImageReference < ActiveRecord::Migration[6.0]
  def change
    remove_reference :images, :about
  end
end
