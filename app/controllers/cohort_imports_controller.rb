class CohortImportsController < ApplicationController
  def new; end

  def create
    if params[:cohort_csv].content_type == 'text/csv'
      upload = FileUpload.create(user: current_user, organization: current_organization, status: 'Pending',
                                 file: params[:cohort_csv])

      ImportCohortsJob.perform_later(upload)

      redirect_to cohorts_path, notice: 'Processing file...'
    else
      redirect_to csv_upload_enclosures_path, error: 'Invalid file type. Please upload a CSV.'
    end
  end
end
