class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
