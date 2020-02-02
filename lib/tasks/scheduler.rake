# frozen_string_literal: true

namespace :scheduler do
  desc 'Delete stale temporary files'
  # This rake task is meant to be run once per day to cleanse temporary files
  # from the database. It will also log if any temporary files have not been
  # successfully processed.
  task delete_stale_temporary_files: :environment do
    # collect all temporary_files over a week old
    TemporaryFile.where('created_at < ?', 7.days.ago).each do |file|
      # check if they have been processed successfully
      if file.processed_file && file.processed_file.status == 'Processed'
        # if yes, then we are safe to destroy the file
        file.destroy
      else
        # if no, then we log the file to be handled later
        warning_message = <<-MESSAGE
          Warning: TemporaryFile with id #{file.id} is more than
          7 days old but has not been processed successfully.
        MESSAGE
        Rails.logger.warn warning_message
      end
    end
  end
end
