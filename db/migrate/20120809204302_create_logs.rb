class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :client
      t.string :check
      t.string :silence_type
      t.string :action_type
      t.string :environment
      t.text :output
      t.text :reason
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end
end
