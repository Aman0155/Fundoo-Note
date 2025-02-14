FactoryBot.define do
  factory :note do
    title { "Sample Note" }
    content { "This is a test note." }
    association :user  # Links the note to a user
  end
end
