class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :type
      t.string :state
      t.references :server, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
