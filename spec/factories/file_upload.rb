FactoryBot.define do
  factory :file_upload do
    user
    organization
    status { 'Pending' }
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'files', 'animals.csv'), 'text/csv') }
  end
end
