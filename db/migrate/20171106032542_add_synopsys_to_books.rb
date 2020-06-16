class AddSynopsysToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :synopsis, :string
    add_column :books, :link, :string
  end
end
