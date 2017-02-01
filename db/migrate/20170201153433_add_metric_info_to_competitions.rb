class AddMetricInfoToCompetitions < ActiveRecord::Migration[5.0]
  def change
    rename_column :competitions, :evaluation_type, :metric
    change_column_default :competitions, :metric, from: 0, to: nil
    add_column :competitions, :metric_sort, :string

    reversible do |dir|
      dir.up do
        Competition.find_each do |comp|
          comp.metric_sort = Metrorb.metrics_hash[comp.metric.to_sym].sort_direction.to_s
          comp.save!
        end
      end
    end
  end
end
