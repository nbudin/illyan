class MakeUrlsAnArray < ActiveRecord::Migration
  def up
    add_column :services, :urls, :string, array: true
    execute "UPDATE services SET urls = ARRAY[url];"
    remove_column :services, :url
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
