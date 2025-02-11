FactoryBot.define do
  factory :evaluation_request do
    association :client, factory: :client
    association :attendant, factory: :attendant
    evaluation_token { SecureRandom.uuid }
    status { 'pending' }
    expires_at { 24.hours.from_now }

    trait :expired do
      expires_at { 1.day.ago }
      status { 'expired' }
    end

    trait :completed do
      status { 'completed' }
    end

    trait :pending do
      status { 'pending' }
    end
  end
end
