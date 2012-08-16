class CreateDowntimes < ActiveRecord::Migration
  def change
    create_table :downtimes do |t|
      t.string :name
      t.text :description
      t.datetime :start_time
      t.datetime :stop_time
      t.integer :user_id
      t.boolean :processed, :default => false
      t.boolean :completed, :default => false
      t.timestamps
    end
  end
end
