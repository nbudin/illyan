FactoryGirl.define do
  factory :service do
    sequence(:name) { |i| "Service #{i}" }
  end
end
