require 'fog/azurerm'

Paperclip::Attachment.default_options[:storage] = :fog
Paperclip::Attachment.default_options[:fog_credentials] = Datoca.config.dig('fog', 'storage', 'credentials')
Paperclip::Attachment.default_options[:fog_directory] = Datoca.config.dig('fog', 'storage', 'directory')
Paperclip::Attachment.default_options[:fog_host] = Datoca.config.dig('fog', 'storage', 'host')


# 🙊 monkeypatch paperclip url generation:
# It didn't use the directory info when the fog_host option was supplied
module Paperclip
  module Storage
    module Fog
      def public_url(style = default_style)
        if @options[:fog_host]
          "#{dynamic_fog_host_for_style(style)}/#{directory_name}/#{path(style)}"
        else
          if fog_credentials[:provider] == 'AWS'
            "#{scheme}://#{host_name_for_directory}/#{path(style)}"
          else
            directory.files.new(:key => path(style)).public_url
          end
        end
      end
    end
  end
end
