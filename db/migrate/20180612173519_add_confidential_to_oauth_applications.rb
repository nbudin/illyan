class AddConfidentialToOauthApplications < ActiveRecord::Migration
  def change
    change_table :oauth_applications do |t|
      t.boolean :confidential, null: false, default: true
    end
  end
end
