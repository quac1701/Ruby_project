class CreateBookCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :book_categories do |t|
      t.references :book, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
