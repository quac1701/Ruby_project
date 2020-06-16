class AddBannedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_banned, :boolean, default: false
  end
end
