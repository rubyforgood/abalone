FactoryBot.define do
  factory :operation_batch do
    sequence(:name) { |n| "Operation #{n}" }
  end
end
