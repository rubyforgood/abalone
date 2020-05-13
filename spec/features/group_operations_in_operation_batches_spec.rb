require 'rails_helper'

RSpec.describe "Group Operations in OperationBatches" do
  it "allows ordered sets of operations swapping families between two tanks" do
    # Swapping families between tanks A and B

    tank_a = FactoryBot.create(:tank)
    family_i = FactoryBot.create(:family, tank: tank_a)
    tank_b = FactoryBot.create(:tank)
    family_j = FactoryBot.create(:family, tank: tank_b)

    tank_c = FactoryBot.create(:tank)

    operation_batch = FactoryBot.create(:operation_batch)

    operation_1 = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                action: :remove_family, tank: tank_a)
    operation_2 = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                action: :add_family, tank: tank_c, family: family_i)
    operation_3 = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                action: :remove_family, tank: tank_b)
    operation_4 = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                action: :add_family, tank: tank_a, family: family_j)
    operation_5 = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                action: :remove_family, tank: tank_c)
    operation_6 = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                action: :add_family, tank: tank_b, family: family_i)


    operation_batch.operations.each(&:perform)
    [tank_a, tank_b, tank_c].each(&:reload)

    aggregate_failures do
      expect(operation_batch.operations[0]).to eq operation_1
      expect(operation_batch.operations[1]).to eq operation_2
      expect(operation_batch.operations[2]).to eq operation_3
      expect(operation_batch.operations[3]).to eq operation_4
      expect(operation_batch.operations[4]).to eq operation_5
      expect(operation_batch.operations[5]).to eq operation_6

      expect(tank_a.family).to eq(family_j)
      expect(tank_b.family).to eq(family_i)
      expect(tank_c).to be_empty
    end
  end
end
