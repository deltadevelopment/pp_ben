class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body
      t.string :media_type
      t.string :media_key
      t.references :sender
      t.references :receiver
      t.timestamps null: false
    end
  end
end
