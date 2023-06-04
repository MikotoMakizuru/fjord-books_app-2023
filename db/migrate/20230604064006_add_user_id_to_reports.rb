class AddUserIdToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :user_id, :integer
    add_index :reports, :user_id
    add_foreign_key :reports, :users
  end
end
