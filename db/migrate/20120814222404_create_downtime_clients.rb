class CreateDowntimeClients < ActiveRecord::Migration
  def change
    create_table :downtime_clients do |t|
      t.string :name
      t.integer :downtime_id

      t.timestamps
    end
  end
end
