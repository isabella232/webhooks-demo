class AddVerificationCodeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :verification_code, :string
    add_column :users, :verified, :boolean, :default => false
    add_column :users, :verification_postcard_id, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :address_line1, :string
    add_column :users, :address_line2, :string
    add_column :users, :address_city, :string
    add_column :users, :address_state, :string
    add_column :users, :address_zip, :string
    add_column :users, :address_country, :string
  end
end
