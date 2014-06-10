FactoryGirl.define do
  factory :transfer1h do
    association :sender, factory: :agent
    association :receiver, factory: :agent
    ammount { 1000 + rand(5..10)*100 }
    payout { ammount*0.1 }
    starts_at { (Time.now - rand(1..3).hours).beginning_of_hour } 
  end
end