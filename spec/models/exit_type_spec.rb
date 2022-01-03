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

    context "with an associated mortality_events" do
      subject(:exit_type) { create(:exit_type) }

      before do
        create(:mortality_event, exit_type: exit_type)
      end

      it "cannot be destroyed" do
        expect { exit_type.destroy }
          .not_to change(ExitType, :count)
      end

      it "adds an error to the exit_type" do
        exit_type.destroy
        expect(exit_type.errors.full_messages)
          .to eq(["Cannot delete record because dependent mortality events exist"])
      end
    end
  end
end
