class Agent < ActiveRecord::Base
  has_many :sended_transfers, class_name: 'Transfer', foreign_key: 'sender_id'
  has_many :received_transfers, class_name: 'Transfer', foreign_key: 'receiver_id'

  has_many :sended_transfer_1hs, class_name: 'Transfer1h', foreign_key: 'sender_id'
  has_many :received_transfer_1hs, class_name: 'Transfer1h', foreign_key: 'receiver_id'

  validates :name, presence: true
end
