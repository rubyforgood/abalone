require 'rails_helper'

RSpec.describe ExitType, type: :model do
  subject(:exit_type) { build_stubbed(:exit_type) }

  describe "Validations >" do
    subject(:exit_type) { build(:exit_type) }

    it "has a valid factory" do
      expect(exit_type).to be_valid
    end

    it_behaves_like OrganizationScope

    it { is_expected.to validate_presence_of(:name) }
  end
end
