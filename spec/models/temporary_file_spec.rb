require 'rails_helper'

RSpec.describe TemporaryFile, type: :model do
  it { should have_one(:processed_file) }
end
