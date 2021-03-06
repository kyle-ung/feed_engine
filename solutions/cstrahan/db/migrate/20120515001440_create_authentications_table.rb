class CreateAuthenticationsTable < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :token
      t.string :secret

      t.timestamps
    end
  end
end
