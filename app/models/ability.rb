class Ability
  include CanCan::Ability
  
  def initialize(person)
    return if person.nil?

    alias_action [:edit_account, :change_password], :to => :update
    
    if person.admin?
      can [:list, :read, :create, :update, :destroy], Person
      can [:list, :read, :create, :update, :destroy], Service
    else
      can [:read, :update, :destroy], Person, :id => person.id
    end
  end
end