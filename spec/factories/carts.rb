FactoryBot.define do
  factory :cart do
    created_at { Time.current }
    abandoned { false }
  end
end