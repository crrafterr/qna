FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }
    question
    user

    trait :invalid_answer do
      body { nil }
    end
  end
end
