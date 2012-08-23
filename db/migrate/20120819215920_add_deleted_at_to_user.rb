class AddDeletedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :timestamp
  end
end
