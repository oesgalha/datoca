class AttachmentsController < ApplicationController
  def show
    @attachment = Attachment.find_by(uuid: params[:uuid])
    if @attachment.is_csv?
      authorize(@attachment)
      send_data @attachment.file.read, filename: @attachment.file_filename, type: @attachment.file_content_type
    else
      raise ActiveRecord::RecordNotFound
    end
  rescue Pundit::NotAuthorizedError
    session[:download_uuid] = params[:uui]
    redirect_to new_competition_acceptance_url(@attachment.competition)
  end
end
