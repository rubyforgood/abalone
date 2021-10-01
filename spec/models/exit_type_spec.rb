require 'rails_helper'

RSpec.describe ExitType, type: :model do
  let(:exit_type) { FactoryBot.create :exit_type }

  include_examples 'organization presence validation' do
    let(:model) { described_class.new name: 'Name of exit type', organization: organization }
  end

  it "must have a name" do
    exit_type.name = "test"
    expect(exit_type).to be_valid

    exit_type.name = ""
    expect(exit_type).not_to be_valid
  end
end
