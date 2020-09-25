class ImportEnclosuresJob < ApplicationJob
  ENCLOSURE_COLUMNS = Enclosure.column_names.freeze

  def perform(upload)
    @status = { created_count: 0, error_count: 0, errors: [] }
    CSV.parse(upload.file.download, headers: true) do |enclosure|
      headers = enclosure.headers & (ENCLOSURE_COLUMNS + %w[facility_code location_name])
      @attrs = enclosure.to_hash.delete_if { |k, _v| !headers.include? k }.deep_symbolize_keys

      # Find facility
      facility_code = @attrs.delete(:facility_code)
      location_name = @attrs.delete(:location_name)
      next unless (facility = find_facility(facility_code, upload.organization))
      next unless (location = find_location(location_name, facility, upload.organization))

      @attrs.merge!({ location_id: location.id, organization_id: upload.organization.id })

      begin
        @status[:created_count] += 1 if Enclosure.create(@attrs)
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid => e
        message = e.instance_of?(ActiveRecord::RecordNotUnique) ? :duplicate : :invalid
        @status[:errors] << { code: facility_code, location_name: location_name, name: @attrs[:name], type: message }
        @status[:error_count] += 1
      end
    end
    upload.update(status: job_status)
  end

  private

  def find_facility(code, organization)
    if (facility = Facility.for_organization(organization).find_by(code: code))
      facility
    else
      @status[:error_count] += 1
      @status[:errors] << { code: code, name: @attrs[:name], type: :no_facility }
      false
    end
  end

  def find_location(location_name, facility, _organization)
    if (location = facility.locations.find_by(name: location_name))
      location
    else
      @status[:error_count] += 1
      @status[:errors] << { code: facility.code, location_name: location_name, name: @attrs[:name], type: :no_location }
      false
    end
  end

  def job_status
    "Completed. Created #{@status[:created_count]} enclosures. #{@status[:error_count]} records had errors: #{error_messages(@status[:errors])}"
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
                when :no_location
                  'could not find associated location'
                else
                  'could not be created'
                end
      "Enclosure at #{error[:code]} in location #{error[:location_name]} with name #{error[:name]} #{message}"
    end.join(', ')
  end
end
