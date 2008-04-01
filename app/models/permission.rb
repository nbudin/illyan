class Permission < ActiveRecord::Base
  establish_connection :users
  belongs_to :role
  belongs_to :person
  belongs_to :permissioned, :polymorphic => true
  
  def object
    return permissioned
  end
  
  def grantee
    if not role.nil?
      return role
    else
      return person
    end
  end
end
