require 'fog/azurerm'
require 'refile/fog'

CSV_CONTENT_TYPES = %w( text/plain text/comma-separated-values text/csv application/csv application/excel application/vnd.ms-excel application/vnd.msexcel )
CDN_DEFAULT_CACHE = 60 * 60 * 24 * 365

fog_storage_config = Datoca.config.dig('fog', 'storage')
cdn_url = Datoca.config.dig('cdn', 'url')
fsc_hash = fog_storage_config.present? ? fog_storage_config.symbolize_keys : nil

Refile.configure do |config|
  config.allow_origin = Datoca.config.base_url
  config.content_max_age = CDN_DEFAULT_CACHE
  config.types[:csv] = Refile::Type.new(:csv, content_type: CSV_CONTENT_TYPES)

  if cdn_url.present?
    config.cdn_host = cdn_url
  end

  if fsc_hash.present?
    config.cache = Refile::Fog::Backend.new(prefix: 'cache', **fsc_hash)
    config.store = Refile::Fog::Backend.new(prefix: 'store', **fsc_hash)
    config.backends['instructions'] = Refile::Fog::Backend.new(prefix: 'instructions', **fsc_hash)
  else
    config.backends['instructions'] = Refile::Backend::FileSystem.new(Rails.root.join('tmp/uploads/instructions').to_s)
  end
end
