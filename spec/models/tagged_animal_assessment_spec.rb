require 'rails_helper'

RSpec.describe TaggedAnimalAssessment, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:measurement_date) }
    it { should validate_presence_of(:shl_case_number) }
    it { should validate_presence_of(:spawning_date) }
    it { should validate_presence_of(:tag) }
    it { should validate_presence_of(:length) }

    it { should validate_numericality_of(:length) }
  end
end
