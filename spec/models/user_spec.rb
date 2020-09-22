require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it "should set a default role of 'user' when created" do
    expect(user.role).to eq 'user'
    expect(user.role).to_not eq 'admin'
  end
end
