class AddNameProfileToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :profile, :text
    add_column :users, :postcode, :string
    add_column :users, :address, :text
  end
end
