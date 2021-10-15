FactoryBot.define do
  factory :blazer_query, class: Blazer::Query do
    name { 'Save the snails!' }
    statement { "SELECT * FROM animals" }
    creator { FactoryBot.create(:creator) }
  end
end
