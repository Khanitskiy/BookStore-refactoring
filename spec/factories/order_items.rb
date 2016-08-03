FactoryGirl.define do
  factory :order_item do
    quantity { rand(1..10) }
    book
    order
  end
end
