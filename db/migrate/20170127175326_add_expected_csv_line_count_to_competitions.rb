class AddExpectedCsvLineCountToCompetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :competitions, :expected_csv_line_count, :integer, default: 0

    reversible do |dir|
      dir.up do
        Competition.find_each do |comp|
          comp.expected_csv_line_count = CSV.new(comp.expected_csv.read).read.size
          comp.save!
        end
      end
    end
  end
end
