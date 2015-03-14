class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string "auth_token"
      t.integer "user_id"
      t.string "device_id"
    end
  end
end
