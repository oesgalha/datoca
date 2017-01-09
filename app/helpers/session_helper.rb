module SessionHelper
  def input_classes
    flash[:alert].present? ? 'input is-danger' : 'input'
  end

  def session_error_msg
    return unless flash[:alert].present?
    content_tag(:div, class: 'notification is-danger') do
      content_tag(:button, class: 'delete') do
      end + flash[:alert]
    end
  end
end
