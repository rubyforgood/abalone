class ImportTanksJob < ApplicationJob
  TANK_COLUMNS = Tank.column_names.freeze

  def perform(upload)
    @status = { created_count: 0, error_count: 0, errors: [] }
    CSV.parse(upload.file.download, headers: true) do |tank|
      headers = tank.headers & (TANK_COLUMNS + %w[facility_code])
      @attrs = tank.to_hash.delete_if { |k, _v| !headers.include? k }.deep_symbolize_keys

      # Find facility
      facility_code = @attrs.delete(:facility_code)
      next unless (facility_id = find_facility_id(facility_code, upload.organization))

      @attrs.merge!({ facility_id: facility_id, organization_id: upload.organization.id })

      begin
        @status[:created_count] += 1 if Tank.create(@attrs)
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid => e
        message = e.instance_of?(ActiveRecord::RecordNotUnique) ? :duplicate : :invalid
        @status[:errors] << { code: facility_code, name: @attrs[:name], type: message }
        @status[:error_count] += 1
      end
    end
    upload.update(status: job_status)
  end

  private

  def find_facility_id(code, organization)
    if (facility_id = Facility.for_organization(organization).find_by(code: code)&.id)
      facility_id
    else
      @status[:error_count] += 1
      @status[:errors] << { code: code, name: @attrs[:name], type: :no_facility }
      false
    end
  end

  def job_status
    "Completed. Created #{@status[:created_count]} tanks. #{@status[:error_count]} records had errors: #{error_messages(@status[:errors])}"
  end

  def error_messages(errors)
    errors.map do |error|
      message = case error[:type]
                when :duplicate
                  'already exists'
                when :invalid
                  'contained invalid data'
                when :no_facility
                  'could not find associated facility'
                else
                  'could not be created'
                end
      "Tank at #{error[:code]} with name #{error[:name]} #{message}"
    end.join(', ')
  end
end
