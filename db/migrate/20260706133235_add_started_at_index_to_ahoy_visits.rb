class AddStartedAtIndexToAhoyVisits < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :ahoy_visits, :started_at, algorithm: :concurrently
  end
end
