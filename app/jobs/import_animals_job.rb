class ImportAnimalsJob < ApplicationJob
  ANIMAL_COLUMNS = Animal.column_names.freeze

  def perform(upload)
    status = { created_count: 0, error_count: 0, errors: [] }
    CSV.parse(upload.file.download, headers: true) do |animal|
      headers = animal.headers & ANIMAL_COLUMNS
      attrs = animal.to_hash.delete_if { |k, _v| !headers.include? k }.deep_symbolize_keys
      next if attrs.values.compact.empty?

      attrs.merge!({ organization_id: upload.organization.id })
      begin
        status[:created_count] += 1 if Animal.create(attrs)
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid => e
        message = e.instance_of?(ActiveRecord::RecordNotUnique) ? :duplicate : :invalid
        status[:errors] << { tag: attrs[:tag], type: message }
        status[:error_count] += 1
      end
    end
    upload.update(status: job_status(status))
  end

  private

  def job_status(status)
    "Completed. Created #{status[:created_count]} animals. #{status[:error_count]} records had errors: #{error_messages(status[:errors])}"
  end

  def error_messages(errors)
    errors.map do |error|
      message = case error[:type]
                when :duplicate
                  'already exists'
                when :invalid
                  'contained invalid data'
                else
                  'could not be created'
                end
      "Animal with Tag #{error[:tag]} #{message}"
    end.join(', ')
  end
end
