class Transfer1h < ActiveRecord::Base
  # rails wants may table to be named transfer_1hs
  # yeah right - why just don't we add an S at the end and make it plural
  self.table_name = "transfers_1h"
  
  include TransferAssociations
  include TransferValidations


  # draw transfer in
  # if no aggreagted transfer is present new one will be created
  def self.aggregate transfer
    # try find an existing Transfer1H 
    aggregation = self.find_by_transfer transfer

    # build new one if not present
    if aggregation.blank?
      aggregation = self.new
    end

    # suck in a transfer
    aggregation.aggregate transfer

    # aaaand just save it )
    aggregation.save
  end


  # find Transfer1h by given Transfer
  def self.find_by_transfer transfer
    self.where(sender_id: transfer.sender_id,
          receiver_id: transfer.receiver_id,
          starts_at: transfer.transfered_at.beginning_of_hour
          ).first
  end

  # draw the transfer in
  def aggregate transfer
    # set for new one or just ignore for exinsting one
    self.sender_id ||= transfer.sender_id
    self.receiver_id ||= transfer.receiver_id
    self.starts_at ||= transfer.transfered_at.beginning_of_hour

    # ammount and payout is zero by default
    self.ammount += transfer.ammount
    self.payout += transfer.payout

    self
  end

  # find all the relevant transfers
  # end of an hour will give you 18:59:59 so no collision in :00:00 time )
  def transfers
    Transfer.where(sender_id: self.sender_id,
          receiver_id: self.receiver_id,
          transfered_at: (self.starts_at..self.starts_at.end_of_hour)
          )
  end
end
