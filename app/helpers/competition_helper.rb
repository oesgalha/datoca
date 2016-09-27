module CompetitionHelper

  TIME_FILTERS = [
    [ 'Ativas', { deadline_gteq: 1.day.since.midnight } ],
    [ 'Todas',  { deadline_gteq: nil } ]
  ]

  EVALUATION_FILTERS = [
    ['Média Absoluta', { evaluation_type_eq: 0 }]
  ]

  ORDER_FILTERS = [
    ['Prêmio', { s: 'total_prize desc' }],
    ['Prazo', { s: 'deadline asc' }]
  ]

  def evaluation_filters
    filters(EVALUATION_FILTERS)
  end

  def time_filters
    filters(TIME_FILTERS)
  end

  def order_filters
    filters(ORDER_FILTERS)
  end

  def params_with_filter(filter_hash)
    params_yield_filter do |ransack_query|
      ransack_query.merge!(filter_hash)
    end
  end

  def params_without_filter(filter_hash)
    params_yield_filter do |ransack_query|
      filter_hash.keys.each { |k| ransack_query.delete(k) }
    end
  end

  def params_yield_filter
    params.permit(q: [params[:q]&.keys]).to_h.deep_dup.tap do |params_copy|
      params_copy[:q] ||= {}
      yield params_copy[:q]
      params_copy
    end
  end

  def filters(options)
    options.map do |label, filter|
      content_tag(:li) do
        link_to_unless_current label, params_with_filter(filter) do
          link_to label, params_without_filter(filter), class: 'is-active'
        end
      end
    end.join.html_safe
  end
end
