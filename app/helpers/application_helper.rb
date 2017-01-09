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

  def image_tag_with_fallback(resource, size)
    class_size = "image is-#{size}x#{size}"
    case resource.class.to_s
    when 'Competition'
      attachment_name = :ilustration
      fallback_name = 'fallback-competition.svg'
    when 'User'
      attachment_name = :avatar
      fallback_name = 'fallback-user.svg'
    when 'Team'
      attachment_name = :avatar
      fallback_name = 'fallback-team.svg'
    end
    attachment_image_tag(resource, attachment_name, :fill, size, size, class: class_size, fallback: fallback_name)
  end
end
