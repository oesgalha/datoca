class AddExpectedCsvLineCountToCompetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :competitions, :expected_csv_line_count, :integer, default: 0
  end
end
