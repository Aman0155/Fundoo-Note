FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "Password@123" }  # Valid password
    phone_number { Faker::PhoneNumber.cell_phone } # Add a valid phone number
  end
end
