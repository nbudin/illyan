class AddAutoAuthorizeToServices < ActiveRecord::Migration
  def change
    add_column :services, :auto_authorize, :boolean, null: false, default: false
  end
end
