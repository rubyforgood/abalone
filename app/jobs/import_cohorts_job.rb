class ImportCohortsJob < ApplicationJob
  def perform(upload)
    @status = { created_count: 0, error_count: 0, errors: [] }
    CSV.parse(upload.file.download, headers: true).each_with_index do |cohort_row, row_num|
      cohort = build_cohort(cohort_row.to_h, upload.organization)

      if cohort.save
        @status[:created_count] += 1
      else
        @status[:errors] << { row: cohort_row.to_s.chomp, row_num: row_num, msg: cohort.errors.messages }
        @status[:error_count] += 1
      end
    end
    upload.update(status: job_status)
  end

  private

  def job_status
    "Completed. Created #{@status[:created_count]} enclosures.\n"\
    "#{@status[:error_count]} records had errors:\n#{error_messages}"
  end

  def error_messages
    @status[:errors].map do |err|
      "Row ##{err[:row_num]} | #{err[:row]} had the following errors: #{err[:msg]}"
    end.join('\n')
  end

  def build_cohort(params, organization)
    Cohort.new(
      {
        name: params['name'],
        female: Animal.new(tag: params['female_tag'], sex: 'female', organization: organization),
        male: Animal.new(tag: params['male_tag'], sex: 'male', organization: organization),
        enclosure: Enclosure.for_organization(organization).find_by(name: params['enclosure']),
        organization: organization
      }
    )
  end
end
