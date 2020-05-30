require 'rails_helper'

RSpec.describe OperationBatch, type: :model do
  it { is_expected.to have_many(:operations) }
end
