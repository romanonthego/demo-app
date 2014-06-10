module TransferAssociations
  extend ActiveSupport::Concern

  included do
    belongs_to :sender, class_name: 'Agent', foreign_key: 'sender_id'
    belongs_to :receiver, class_name: 'Agent', foreign_key: 'receiver_id'
  end
  
end