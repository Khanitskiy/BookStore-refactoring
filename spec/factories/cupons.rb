FactoryGirl.define do
  factory :cupon do
    value             { Faker::Lorem.characters(9) }
    use               { [true, false].sample }
    discount          { [5, 10, 15].sample }
  end
end
