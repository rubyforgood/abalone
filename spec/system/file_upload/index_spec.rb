require 'rails_helper'

describe "When i visit the file upload index page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  context "after uploading a valid file" do
    before do
      create(:processed_file, organization: user.organization)
      visit file_uploads_path
    end

    it "should have a success icon" do
      within('tbody') do
        expect(page).to have_css('.fa-check')
      end
    end
    it "should have a show link" do
      within('tbody') do
        expect(page).to have_link("Show")
      end
    end
    it "should not have a delete link" do
      within('tbody') do
        expect(page).not_to have_selector("a[data-method='delete']")
      end
    end
  end

  context "after uploading an invalid file" do
    before do
      create(:processed_file, organization: user.organization, status: "Failed", job_errors: "Errors messages")
      visit file_uploads_path
    end

    it "should have a failed icon" do
      within('tbody') do
        expect(page).to have_css('.fa-exclamation-triangle')
      end
    end

    it "should not have a show link" do
      within('tbody') do
        expect(page).not_to have_link("Show")
      end
    end

    it "should have a delete link" do
      within('tbody') do
        expect(page).to have_selector("a[data-method='delete']")
      end
    end

    it "should have error messages" do
      within('tbody') do
        expect(page).to have_content("Errors messages")
      end
    end
  end

  context "after uploading a file and it is still running" do
    before do
      create(:processed_file, organization: user.organization, status: "Running")
      visit file_uploads_path
    end

    it "should have a failed icon" do
      within('tbody') do
        expect(page).to have_css('.fa-spinner')
      end
    end

    it "should not have a show link" do
      within('tbody') do
        expect(page).not_to have_link("Show")
      end
    end
  end
end
