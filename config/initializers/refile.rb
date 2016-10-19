CSV_CONTENT_TYPES = %w( text/plain text/comma-separated-values text/csv application/csv application/excel application/vnd.ms-excel application/vnd.msexcel )

CDN_WITHOUT_CACHE = 0
CDN_DEFAULT_CACHE = 60 * 60 * 24 * 365

Refile.backends['instructions'] = Refile::Backend::FileSystem.new(Rails.root.join("tmp/uploads/instructions").to_s)

Refile.configure do |config|
  config.allow_origin = Datoca.config.base_url
  config.types[:csv] = Refile::Type.new(:csv, content_type: CSV_CONTENT_TYPES)
end

Refile.cdn_host = Datoca.config.dig('cdn', 'url')

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
