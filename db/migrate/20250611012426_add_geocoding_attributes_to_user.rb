class AddGeocodingAttributesToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :latitude, :string
    add_column :users, :longitude, :string
    add_column :users, :state, :string
    add_column :users, :geolocation_process_status, :string, default: "undefined"
  end
end
