require 'fog/azurerm'
require 'refile/fog'

CSV_CONTENT_TYPES = %w( text/plain text/comma-separated-values text/csv application/csv application/excel application/vnd.ms-excel application/vnd.msexcel )

CDN_WITHOUT_CACHE = 0
CDN_DEFAULT_CACHE = 60 * 60 * 24 * 365

fog_storage_config = Datoca.config.dig('fog', 'storage')

if fog_storage_config.present?
  fsc_hash = fog_storage_config.symbolize_keys
  Refile.configure do |config|
    config.cache = Refile::Fog::Backend.new(prefix: "cache", **fsc_hash)
    config.store = Refile::Fog::Backend.new(prefix: "store", **fsc_hash)
  end
  Refile.backends['instructions'] = Refile::Fog::Backend.new(prefix: "instructions", **fsc_hash)
else
  Refile.backends['instructions'] = Refile::Backend::FileSystem.new(Rails.root.join("tmp/uploads/instructions").to_s)
end

Refile.configure do |config|
  config.allow_origin = Datoca.config.base_url
  config.types[:csv] = Refile::Type.new(:csv, content_type: CSV_CONTENT_TYPES)
end

cdn_url = Datoca.config.dig('cdn', 'url')
Refile.cdn_host = cdn_url if cdn_url.present?

def parse_path(path)
  path.split('/')[3..4]
end

def get_user_id(session)
  session.to_hash.dig('warden.user.user.key', 0, 0)
end

def acceptance_url(file)
  Datoca::Application.routes.url_helpers.new_competition_acceptance_url(competition, host: Datoca.config.base_url)
end

Refile::App.before do
  backend, file_id = parse_path(request.path)
  return unless backend == 'instructions'
  file = Attachment.find_by(file_id: file_id)
  return unless file&.is_csv?
  competition = file.competition
  if competition.files_can_be_downloaded_by?(get_user_id(session))
    Refile.content_max_age = CDN_WITHOUT_CACHE
  else
    redirect(acceptance_url(competition))
  end
end

Refile::App.after do
  Refile.content_max_age = CDN_DEFAULT_CACHE
end
