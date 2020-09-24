module CsvExportable
  extend ActiveSupport::Concern

  class_methods do
    def exportable_columns
      column_names.reject { |col| %w[organization_id].include? col }
    end

    def to_csv
      CSV.generate(headers: true) do |csv|
        csv << exportable_columns
        all.each { |record| csv << exportable_columns.map { |attr| record.send(attr) } }
      end
    end
  end
end
