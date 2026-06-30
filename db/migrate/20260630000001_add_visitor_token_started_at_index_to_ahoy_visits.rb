class AddVisitorTokenStartedAtIndexToAhoyVisits < ActiveRecord::Migration[8.1]
  def change
    add_index :ahoy_visits, [:visitor_token, :started_at]
  end
end
