require 'spec_helper'

describe Transfer do
  let (:sender) { create(:agent) }
  let (:receiver) { create(:agent) }
  let (:transfer) { build(:transfer, sender: sender, receiver: receiver) }


  it "is be builded valid" do
    expect(transfer.valid?).to be_true
  end


  describe 'validations' do
    it { expect(transfer).to validate_presence_of(:sender_id) }
    it { expect(transfer).to validate_presence_of(:receiver_id) }
    it { expect(transfer).to validate_presence_of(:ammount) }
    it { expect(transfer).to validate_numericality_of(:ammount) }
    it { expect(transfer).to validate_numericality_of(:payout) }
  end


  describe 'associations' do
    it { expect(transfer).to belong_to(:sender) }
    it { expect(transfer).to belong_to(:receiver) }
  end


  describe 'instance methods' do
    # TODO: add later, they are obvious
  end


  describe 'class methods' do
    # TODO: add later, they are obvious
  end


  describe 'callbacks' do
    let (:transfer) { create(:transfer, sender: sender, receiver: receiver)}

    it 'should run after save callback' do
      expect(transfer).to callback(:aggregate).after(:create)
    end
  end


  describe 'existence of aggregated entity for saved transfer' do
    let (:transfer) { create(:transfer, sender: sender, receiver: receiver)}

    it 'should have one aggregated transfer entry' do
      expect(transfer.relevant_aggregated_transfer).to be_kind_of(Transfer1h)
    end
  end
end