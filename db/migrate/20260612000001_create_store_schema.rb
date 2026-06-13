class CreateStoreSchema < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.boolean :admin, default: false, null: false

      t.timestamps
    end
    add_index :users, :email, unique: true

    create_table :categories do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
    add_index :categories, :name, unique: true

    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false, default: 0
      t.integer :stock, null: false, default: 0
      t.string :image_url
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    create_table :carts do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end

    create_table :line_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end
    add_index :line_items, [ :cart_id, :product_id ], unique: true

    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total, precision: 10, scale: 2, null: false, default: 0
      t.string :status, null: false, default: "pending"

      t.timestamps
    end

    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.decimal :unit_price, precision: 10, scale: 2, null: false

      t.timestamps
    end

    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :comment, null: false

      t.timestamps
    end
    add_index :reviews, [ :user_id, :product_id ], unique: true
  end
end
