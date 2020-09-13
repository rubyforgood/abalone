require 'rails_helper'

describe "download CSV file from upload files", type: :feature do
  let(:user) { create(:user) }

  it "When I click on previous file name I download csv file" do
    file = FactoryBot.create(:processed_file)
    sign_in user
    visit file_uploads_path
    click_on(file.filename)
    filename = file.filename.gsub('(', '%28').gsub(')', '%29')
    expect(page.response_headers['Content-Disposition']).to include(filename)
  end
end
