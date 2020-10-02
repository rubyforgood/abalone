require 'rails_helper'

RSpec.describe Operation, type: :model do
  subject(:operation) { FactoryBot.build(:operation, enclosure: enclosure, cohort: cohort, action: action) }
  let(:action) { nil }
  let(:enclosure) { FactoryBot.build(:enclosure) }
  let(:cohort) { FactoryBot.build(:cohort) }

  it { is_expected.to belong_to(:enclosure) }
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to belong_to(:cohort).required(false) }

  describe "validations" do
    context 'When the action is :add_cohort' do
      let(:action) { :add_cohort }
      it { is_expected.to validate_presence_of(:cohort) }
    end
  end

  describe "#perform" do
    context "valid actions" do
      before { operation.perform }

      context "When action is :add_cohort" do
        let(:action) { :add_cohort }
        it "sets the enclosure cohort and cohort enclosure" do
          aggregate_failures do
            expect(enclosure.cohort).to eq cohort
            expect(cohort.enclosure).to eq enclosure
          end
        end
      end

      context "When action is :remove_cohort" do
        let(:action) { :remove_cohort }
        context 'And the optional cohort is included' do
          it 'unsets the enclosure for the cohort' do
            aggregate_failures do
              expect(enclosure.cohort).to eq nil
              expect(cohort.enclosure).to eq nil
            end
          end
        end
        context 'And the optional cohort is not included' do
          let(:cohort) { nil }
          it "unsets the enclosure for the cohort" do
            expect(enclosure.cohort).to eq nil
          end
        end
      end
    end

    context 'When the action is invalid' do
      # For raise_error assertions, they expect the subject to be a lambda
      # However, subject is often a value; so the `it { is_expected.to ...}`
      # syntax does not always play nicely.
      #
      # We wrap operation.perform call in a proc so that the lambda expression
      # can be evaluated by the raise_error block.
      #
      # This is part of why some codebases prefer to avoid the "it { ... }" syntax
      # in favor of "it 'words' do ... end" syntax.
      subject(:proc) { -> { operation.perform } }
      let(:action) { :eat_cohort }
      it { is_expected.to raise_error(Operation::InvalidActionError) }
    end
  end

  include_examples 'organization presence validation' do
    let(:model) { described_class.new enclosure: create(:enclosure), organization: organization }
  end
end
