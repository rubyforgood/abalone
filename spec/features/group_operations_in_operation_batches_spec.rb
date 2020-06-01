require 'rails_helper'

RSpec.describe "Group Operations in OperationBatches" do
  it "allows ordered sets of operations swapping families between two tanks" do
    # Swapping families between tanks A and B

    tank_one = FactoryBot.create(:tank)
    family_one = FactoryBot.create(:family, tank: tank_one)
    tank_two = FactoryBot.create(:tank)
    family_two = FactoryBot.create(:family, tank: tank_two)

    tank_three = FactoryBot.create(:tank)

    operation_batch = FactoryBot.create(:operation_batch)

    operation_one = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                  action: :remove_family, tank: tank_one)
    operation_two = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                  action: :add_family, tank: tank_three, family: family_one)
    operation_three = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                    action: :remove_family, tank: tank_two)
    operation_four = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                   action: :add_family, tank: tank_one, family: family_two)
    operation_five = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                   action: :remove_family, tank: tank_three)
    operation_six = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                  action: :add_family, tank: tank_two, family: family_one)

    operation_batch.reload.operations.each(&:perform)
    [operation_batch, family_one, family_two, tank_one, tank_two, tank_three].each(&:reload)

    aggregate_failures do
      expect(operation_batch.operations[0]).to eq operation_one
      expect(operation_batch.operations[1]).to eq operation_two
      expect(operation_batch.operations[2]).to eq operation_three
      expect(operation_batch.operations[3]).to eq operation_four
      expect(operation_batch.operations[4]).to eq operation_five
      expect(operation_batch.operations[5]).to eq operation_six

      expect(tank_one.family).to eq(family_two)
      expect(tank_two.family).to eq(family_one)
      expect(tank_three).to be_empty
    end
  end
end
