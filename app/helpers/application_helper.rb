module ApplicationHelper

  FLASH_CLASS = {
    'notice'  => 'is-info',
    'alert'   => 'is-warning',
    'error'   => 'is-danger'
  }

  def has_flash?
    !flash.empty?
  end

  def flash_msgs
    flash.each.map do |sym, msg|
      <<-HTML.strip_heredoc
      <div class="notification #{FLASH_CLASS[sym]}">
        <button class="delete"></button>
        #{msg}
      </div>
      HTML
    end.join.html_safe
  end
end
