require 'spec_helper'

describe Agent do
  let (:sender) { create(:agent) }
  
  it "is be builded valid" do
    expect(sender.valid?).to be_true
  end

  describe 'validations' do
    it { expect(sender).to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { expect(sender).to have_many(:sended_transfers) }
    it { expect(sender).to have_many(:received_transfers) }
    it { expect(sender).to have_many(:sended_transfer_1hs) }
    it { expect(sender).to have_many(:received_transfer_1hs)}
  end
end