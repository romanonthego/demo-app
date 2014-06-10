class Transfer < ActiveRecord::Base
  include TransferAssociations
  include TransferValidations

  # I don't want to put it in separate method so there
  after_create :aggregate

  # i don't want to hack the relations so i just put it like method
  def relevant_aggregated_transfer
    Transfer1h.find_by_transfer self
  end

  private
  def aggregate
    ::Transfer1h.aggregate(self)
  end
end
