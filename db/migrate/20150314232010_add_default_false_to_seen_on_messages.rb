class AddDefaultFalseToSeenOnMessages < ActiveRecord::Migration
  def change
    change_column :messages, :seen, :boolean, :default => false
  end
end
