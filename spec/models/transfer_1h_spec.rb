require 'spec_helper'

describe Transfer1h do
  let (:sender) { create(:agent) }
  let (:receiver) { create(:agent) }
  let (:transfer1h) { build(:transfer1h, sender: sender, receiver: receiver) }


  it "is be builded valid" do
    expect(transfer1h.valid?).to be_true
  end


  describe 'validations' do
    it { expect(transfer1h).to validate_presence_of(:sender_id) }
    it { expect(transfer1h).to validate_presence_of(:receiver_id) }
    it { expect(transfer1h).to validate_presence_of(:ammount) }
    it { expect(transfer1h).to validate_numericality_of(:ammount) }
    it { expect(transfer1h).to validate_numericality_of(:payout) }
  end


  describe 'associations' do
    it { expect(transfer1h).to belong_to(:sender) }
    it { expect(transfer1h).to belong_to(:receiver) }
  end


  describe 'instance methods' do
    # TODO: add later, they are obvious
  end


  describe 'class methods' do
    # TODO: add later, they are obvious
  end


  describe 'aggregation of transfers' do
    let (:transfer) { create(:transfer, sender: sender, receiver: receiver, transfered_at: Time.now) }
    let (:transfer2) { build(:transfer, sender: sender, receiver: receiver, transfered_at: Time.now) }
    let (:aggregated_transfer) { transfer.relevant_aggregated_transfer }

    let (:ammount) { transfer.ammount.to_f }
    let (:payout) { transfer.payout.to_f }

    let (:ammount_summ) {transfer.ammount.to_f + transfer2.ammount.to_f }
    let (:payout_summ) {transfer.payout.to_f + transfer2.payout.to_f }

    it "saving of an transfer should generate an aggreageted transfer" do
      expect(aggregated_transfer.ammount.to_f).to be_equal(ammount)
      expect(aggregated_transfer.payout.to_f).to be_equal(payout)
    end

    it 'saving two transfer should generate an aggreageted transfer' do
      transfer2.save
      expect(aggregated_transfer.ammount.to_f).to be_equal(ammount_summ)
      expect(aggregated_transfer.payout.to_f).to be_equal(payout_summ)
    end
  end


  describe 'transfers included in aggreagetion' do
    let (:transfer) { create(:transfer, sender: sender, receiver: receiver, transfered_at: Time.now) }
    let (:transfer2) { create(:transfer, sender: sender, receiver: receiver, transfered_at: Time.now) }
    let (:aggregated_transfer) { transfer.relevant_aggregated_transfer }
    let (:count) { 2 }

    it 'aggreageted transfer should have an array of included transfers' do
      expect(aggregated_transfer.transfers).to be_kind_of(ActiveRecord::Relation)
    end

    it 'aggreageted transfer should have an array with length equal to count of transfers saved' do
      transfer2 # just call it to initialize
      expect(aggregated_transfer.transfers.count).to be_equal(count)
    end

    it 'aggreageted transfer should have an array with saved transfers' do
      expect(transfer).to be_in(aggregated_transfer.transfers)
      expect(transfer2).to be_in(aggregated_transfer.transfers)
    end
  end
end