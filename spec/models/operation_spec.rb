require 'rails_helper'

RSpec.describe Operation, type: :model do
  subject(:operation) { FactoryBot.build(:operation, tank: tank, family: family, action: action) }
  let(:action) { nil }
  let(:tank) { FactoryBot.build(:tank) }
  let(:family) { FactoryBot.build(:family) }

  it { is_expected.to belong_to(:tank) }
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to belong_to(:family).required(false) }

  describe "validations" do
    context 'When the action is :add_family' do
      let(:action) { :add_family }
      it { is_expected.to validate_presence_of(:family) }
    end
  end

  describe "#perform" do
    context "valid actions" do
      before { operation.perform }

      context "When action is :add_family" do
        let(:action) { :add_family }
        it "sets the tank family and family tank" do
          aggregate_failures do
            expect(tank.family).to eq family
            expect(family.tank).to eq tank
          end
        end
      end

      context "When action is :remove_family" do
        let(:action) { :remove_family }
        context 'And the optional family is included' do
          it 'unsets the tank for the family' do
            aggregate_failures do
              expect(tank.family).to eq nil
              expect(family.tank).to eq nil
            end
          end
        end
        context 'And the optional family is not included' do
          let(:family) { nil }
          it "unsets the tank for the family" do
            expect(tank.family).to eq nil
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
      let(:action) { :eat_family }
      it { is_expected.to raise_error(Operation::InvalidActionError) }
    end
  end
end
