class ChangeTypeOfMediaTypeOnMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :media_type 
    add_column :messages, :media_type, :integer, :default => 0
  end
end
