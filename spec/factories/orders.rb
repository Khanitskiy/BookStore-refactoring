FactoryGirl.define do
  factory :order do
    state { ['in_progress', 
             'in_queue', 
             'in_delivery', 
             'delivered', 
             'canceled'].sample }
    delivery { rand(0.0..100.0) }
    order_total { rand(0.0..100.0) }
    total_price { rand(0.0..100.0) }
    completed_date { Date.today.next_day }
    book_count { rand(1..10) }
    step_number { rand(0..4) }
    user
    credit_card

    factory :order_with_items do
      transient do
        order_items_count { rand(1..10) }
      end
      after(:create) do |order, evaluator|
        items = create_list(:order_item, evaluator.order_items_count, order: order)
        order.order_items << items
        order.save
      end
    end
  end
end
