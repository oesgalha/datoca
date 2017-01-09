class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.ranked(order)
    rank_node = Arel::Nodes::SqlLiteral.new 'rank()'
    window = Arel::Nodes::Window.new.order(arel_table[order].asc)
    over_node = Arel::Nodes::Over.new rank_node, window
    from(Arel::Nodes::TableAlias.new(current_scope.arel.project(over_node), table_name).to_sql)
  end
end
