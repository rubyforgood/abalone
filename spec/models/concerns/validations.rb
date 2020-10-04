shared_examples_for 'happy path' do
  it 'can be saved with valid attributes' do
    expect { described_class.create!(valid_attributes) }.not_to raise_error
  end
end

shared_examples_for 'a required field' do |field_name|
  it "cannot be saved without #{field_name}" do
    expect { described_class.create!(valid_attributes.except(field_name)) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: #{field_name.to_s.humanize} can't be blank")
  end
end

shared_examples_for 'an optional field' do |field_name|
  it "can be saved without #{field_name}" do
    valid_attributes[field_name] = ''

    expect { described_class.create!(valid_attributes) }.not_to raise_error

    valid_attributes[field_name] = nil

    expect { described_class.create!(valid_attributes) }.not_to raise_error
  end
end

shared_examples_for 'a numeric field' do |field_name|
  it "only accepts numbers for #{field_name}" do
    valid_attributes[field_name] = 'a'

    expect { described_class.create!(valid_attributes) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: #{field_name.to_s.humanize} is not a number")
  end
end

shared_examples_for 'validate values for field' do |field_name|
  it 'can be saved with valid values' do
    valid_values.each do |value|
      attributes = valid_attributes.dup

      attributes[field_name] = value

      described_class.new(attributes).tap do |instance|
        expect { instance.save! }.not_to raise_error
      rescue RSpec::Expectations::ExpectationNotMetError => e
        e.message << "\n\nFailed value was: #{value}"

        raise e
      end
    end
  end

  it 'cannot be saved with invalid values' do
    invalid_values.each do |value|
      described_class.new(valid_attributes).tap do |instance|
        instance.update(field_name => value)

        begin
          expect { instance.save! }.to raise_error ActiveRecord::RecordInvalid
        rescue RSpec::Expectations::ExpectationNotMetError => e
          e.message << "\n\nFailed value was: #{value}"

          raise e
        end
      end
    end
  end
end

shared_examples_for 'organization presence validation' do
  let(:model) { described_class.new organization: organization }

  context 'with organization' do
    context 'when organization is nil' do
      let(:organization) { nil }

      it 'is invalid' do
        expect(model).not_to be_valid
      end
    end

    context 'when organization is present' do
      let(:organization) { create(:organization) }

      it 'is valid' do
        expect(model).to be_valid
      end
    end
  end
end

shared_examples_for OrganizationScope do
  it { is_expected.to validate_presence_of :organization }
end
