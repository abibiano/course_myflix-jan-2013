class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.text :transaction_id
      t.integer :user_id
      t.decimal :amount, preciosion: 8, scale: 2

      t.timestamps
    end
  end
end
