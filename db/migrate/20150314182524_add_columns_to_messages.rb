class AddColumnsToMessages < ActiveRecord::Migration
  def change
    change_table :messages do |t|
      t.boolean :seen
      t.references :parent_message
    end
  end
end
