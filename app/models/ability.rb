class Ability
  include CanCan::Ability
  
  def initialize(principal)
    return if principal.nil?

    alias_action [:edit_account, :change_password], :to => :update
    
    case principal
    when Person
      if principal.admin?
        can [:list, :read, :create, :update, :destroy], Person
        can [:list, :read, :create, :update, :destroy], Service
      else
        can [:read, :update, :destroy], Person, :id => principal.id
      end
    when Service
      can [:read, :create], Person
      can [:read], Service, :id => principal.id
    end
  end
end