class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string     :title
      t.text       :description
      t.decimal    :price
      t.integer    :in_stock
      t.decimal		 :rating
      t.belongs_to :author, index: true
      t.belongs_to :category, index: true

      t.timestamps null: false
    end
  end
end
