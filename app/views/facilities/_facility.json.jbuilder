# frozen_string_literal: true

json.extract! facility, :id, :name, :code, :created_at, :updated_at
json.url facility_url(facility, format: :json)
