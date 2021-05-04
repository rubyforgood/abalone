class CohortImportsController < ApplicationController
  def new
    @cohort_import_form = CsvImportForm.new
  end

  def create
    @cohort_import_form = CsvImportForm.new csv_file: params.dig(:csv_import_form, :csv_file)

    if @cohort_import_form.save(user: current_user, organization: current_organization)
      redirect_to cohorts_path, notice: 'Processing file...'
    else
      render :new
    end
  end
end
