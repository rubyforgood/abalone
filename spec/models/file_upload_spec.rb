require "rails_helper"

describe FileUpload do
  subject(:file_upload) { build_stubbed(:file_upload) }

  it "has associations" do
    is_expected.to belong_to(:user)
  end

  describe "Validations >" do
    subject(:file_upload) { build(:file_upload) }

    it "has a valid factory" do
      expect(file_upload).to be_valid
    end

    include_examples OrganizationScope

    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:user) }
  end
end
