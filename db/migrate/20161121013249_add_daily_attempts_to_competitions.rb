class AddDailyAttemptsToCompetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :competitions, :daily_attempts, :integer, default: 3
  end
end
