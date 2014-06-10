FactoryGirl.define do
  factory :transfer do
    association :sender, factory: :agent
    association :receiver, factory: :agent
    ammount { 1000 + rand(5..10)*100 }
    payout { ammount*0.1 }
    transfered_at { Time.now - rand(1..3).hours } 
  end
end