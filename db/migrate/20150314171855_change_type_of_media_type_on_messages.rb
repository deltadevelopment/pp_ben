class ChangeTypeOfMediaTypeOnMessages < ActiveRecord::Migration
  def change
    change_column :messages, :media_type, :integer, :default => 0
  end
end
