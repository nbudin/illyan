class ConvertCastronautTablesToCassy < ActiveRecord::Migration
  def change
    rename_table :login_tickets, :casserver_lt
    change_table :casserver_lt do |t|
      t.rename :created_at, :created_on
      t.rename :consumed_at, :consumed
      
      t.change :created_on, :timestamp, :null => false
    end
    
    rename_table :service_tickets, :casserver_st
    change_table :casserver_st do |t|
      t.rename :created_at, :created_on
      t.rename :consumed_at, :consumed
      t.rename :proxy_granting_ticket_id, :granted_by_pgt_id
      t.rename :ticket_granting_ticket_id, :granted_by_tgt_id
      
      t.change :created_on, :timestamp, :null => false
      t.change :type, :string, :null => false
    end
    
    rename_table :ticket_granting_tickets, :casserver_tgt
    change_table :casserver_tgt do |t|
      t.rename :created_at, :created_on
      t.text :extra_attributes, :null => false
      
      t.change :created_on, :timestamp, :null => false
    end
    
    rename_table :proxy_granting_tickets, :casserver_pgt
    change_table :casserver_pgt do |t|
      t.rename :created_at, :created_on
      
      t.change :created_on, :timestamp, :null => false
    end
  end
end
