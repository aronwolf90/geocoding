class AddPostalAddressToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :zip_code, :string, null: false
    add_column :users, :street, :string, null: false
    add_column :users, :city, :string, null: false
    add_column :users, :country, :string, null: false
  end
end
