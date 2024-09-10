FactoryBot.define do
  factory :answer do
    body { "MyString" }

    trait :invalid_answer do
      body { nil }
    end
  end
end
