FactoryBot.define do
  factory :service do
    sequence(:name) { |i| "Service #{i}" }
    urls { ['https://google.com', 'http://stuff.com'] }
  end
end
