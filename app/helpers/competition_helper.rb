module CompetitionHelper

  TIME_FILTERS = [
    [ 'Ativas', { deadline_gteq: 1.day.since.midnight } ],
    [ 'Todas',  { deadline_gteq: nil } ]
  ]

  ORDER_FILTERS = [
    ['Prêmio', { s: 'total_prize desc' }],
    ['Prazo', { s: 'deadline asc' }]
  ]

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

  def instructions_error(competition)
    return if competition.errors&.messages&.dig(:instructions).blank?
    content_tag(:div, class: 'notification is-danger') do
      content_tag(:button, class: 'delete') do
      end + competition.errors.messages[:instructions].join
    end
  end

  def competition_deadline_text(competition)
    if Time.current < competition.deadline
      distance_of_time_in_words_to_now(competition.deadline)
    else
      'finalizada'
    end
  end
end
