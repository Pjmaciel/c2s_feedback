FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    role { 'client' }

    trait :with_client_profile do
      after(:create) do |user|
        create(:client_profile, user: user)
      end
    end

    trait :with_attendant_profile do
      role { 'attendant' }
      after(:create) do |user|
        create(:attendant_profile, user: user)
      end
    end

    trait :with_manager_profile do
      role { 'manager' }
      after(:create) do |user|
        create(:manager_profile, user: user)
      end
    end

    factory :client do
      role { 'client' }
      after(:create) do |user|
        create(:client_profile, user: user)
      end
    end

    factory :attendant do
      role { 'attendant' }
      after(:create) do |user|
        create(:attendant_profile, user: user)
      end
    end

    factory :manager do
      role { 'manager' }
      after(:create) do |user|
        create(:manager_profile, user: user)
      end
    end
  end
end
