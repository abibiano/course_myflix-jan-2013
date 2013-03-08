class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.string :friend_full_name
      t.string :friend_email
      t.text :message
      t.string :token

      t.timestamps
    end
  end
end
