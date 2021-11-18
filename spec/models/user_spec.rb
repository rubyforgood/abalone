require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  describe "Validations >" do
    subject(:user) { build(:user) }

    it "has a valid factory" do
      expect(user).to be_valid
    end

    it_behaves_like OrganizationScope

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe "Callbacks >" do
    it "initializes with a default role of 'user'" do
      expect(User.new.role).to eq("user")
    end
  end
end
