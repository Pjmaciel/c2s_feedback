FactoryBot.define do
  factory :evaluation do
    association :client, factory: :client
    association :attendant, factory: :attendant
    score { rand(0..10) }
    comment { Faker::Lorem.paragraph(sentence_count: 2) }
    evaluation_date { Time.current }
  end
end