class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :text
      t.integer :rating
      t.integer :video_id
      t.integer :user_id
      
      t.timestamp
    end
  end
end
