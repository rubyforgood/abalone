require 'rails_helper'

describe "Group Operations in OperationBatches", type: :system do
  it "allows ordered sets of operations swapping cohorts between two enclosures" do
    # Swapping cohorts between enclosures A and B

    enclosure_one = FactoryBot.create(:enclosure)
    cohort_one = FactoryBot.create(:cohort, enclosure: enclosure_one)
    enclosure_two = FactoryBot.create(:enclosure)
    cohort_two = FactoryBot.create(:cohort, enclosure: enclosure_two)

    enclosure_three = FactoryBot.create(:enclosure)

    operation_batch = FactoryBot.create(:operation_batch)

    operation_one = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                  action: :remove_cohort, enclosure: enclosure_one)
    operation_two = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                  action: :add_cohort, enclosure: enclosure_three, cohort: cohort_one)
    operation_three = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                    action: :remove_cohort, enclosure: enclosure_two)
    operation_four = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                   action: :add_cohort, enclosure: enclosure_one, cohort: cohort_two)
    operation_five = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                   action: :remove_cohort, enclosure: enclosure_three)
    operation_six = FactoryBot.create(:operation, operation_batch: operation_batch,
                                                  action: :add_cohort, enclosure: enclosure_two, cohort: cohort_one)

    operation_batch.reload.operations.each(&:perform)
    [operation_batch, cohort_one, cohort_two, enclosure_one, enclosure_two, enclosure_three].each(&:reload)

    aggregate_failures do
      expect(operation_batch.operations[0]).to eq operation_one
      expect(operation_batch.operations[1]).to eq operation_two
      expect(operation_batch.operations[2]).to eq operation_three
      expect(operation_batch.operations[3]).to eq operation_four
      expect(operation_batch.operations[4]).to eq operation_five
      expect(operation_batch.operations[5]).to eq operation_six

      expect(enclosure_one.cohort).to eq(cohort_two)
      expect(enclosure_two.cohort).to eq(cohort_one)
      expect(enclosure_three).to be_empty
    end
  end
end
