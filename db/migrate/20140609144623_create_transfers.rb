class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.decimal :ammount, default: 0, precision: 12, scale: 2
      t.decimal :payout, default: 0, precision: 12, scale: 2
      t.datetime :transfered_at

      t.timestamps
    end
  end
end
