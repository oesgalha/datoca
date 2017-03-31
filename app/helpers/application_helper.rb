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
    when 'User'
      attachment_name = :avatar
    when 'Team'
      attachment_name = :avatar
    end
    case size
    when 32
      size_name = :min
    when 64
      size_name = :med
    when 128
      size_name = :big
    end
    image_tag resource.send(attachment_name).send(:url, size_name), class: class_size
  end
end
