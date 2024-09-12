FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }

    trait :invalid_answer do
      body { nil }
    end
  end
end
