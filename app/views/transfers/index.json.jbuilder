json.array!(@transfers) do |transfer|
  json.extract! transfer, :id, :id, :sender_id, :reciever_id, :ammount, :payout, :transfered_at
  json.url transfer_url(transfer, format: :json)
end
