FactoryBot.define do
  factory :client_profile do
    user
    cpf { CPF.generate }
  end

  factory :attendant_profile do
    user
    sequence(:registration_number) { |n| "V#{format('%04d', n)}" }
  end

  factory :manager_profile do
    user
    sequence(:registration_number) { |n| "G#{format('%04d', n)}" }
  end
end