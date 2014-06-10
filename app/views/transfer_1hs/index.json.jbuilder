json.array!(@transfer_1hs) do |transfer_1h|
  json.extract! transfer_1h, :id, :id, :sender_id, :reciever_id, :ammount, :payout, :starts_at
  json.url transfer_1h_url(transfer_1h, format: :json)
end
