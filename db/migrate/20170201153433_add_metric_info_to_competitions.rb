class AddMetricInfoToCompetitions < ActiveRecord::Migration[5.0]
  def change
    rename_column :competitions, :evaluation_type, :metric
    change_column_default :competitions, :metric, from: 0, to: nil
    add_column :competitions, :metric_sort, :string, default: 'asc'
  end
end
