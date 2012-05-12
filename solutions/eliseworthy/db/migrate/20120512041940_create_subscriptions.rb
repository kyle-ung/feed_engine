class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :provider
      t.string :uid
      t.string :user_name
      t.integer :user_id

      t.timestamps
    end
  end
end
