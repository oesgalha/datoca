# OH MY 🙊
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  tag = Nokogiri::HTML::DocumentFragment.parse(html_tag).at('input,textarea')
  if tag
    tag['class'] = (tag['class'] || '').split.push('is-danger').join(' ')
    errors = instance.error_message.map do |error_msg|
      "<span class=\"help is-danger\">#{error_msg}</span>"
    end
    (tag.to_s + errors.join).html_safe
  else
    html_tag
  end
end
