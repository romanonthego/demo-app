module TransferValidations
  extend ActiveSupport::Concern

  included do
    validates :sender_id, presence: true
    validates :receiver_id, presence: true
    validates :ammount, presence: true
    validates_numericality_of :ammount, greater_than_or_equal_to: 0
    validates_numericality_of :payout, greater_than_or_equal_to: 0
  end
end