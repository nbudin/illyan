class Ability
  include CanCan::Ability
  
  def initialize(person)
    if person.admin?
      can [:read, :create, :update, :destroy], Person
      can [:read, :create, :update, :destroy], Service
    else
      can [:read, :create, :update, :destroy], Person, :person_id => person.id
    end
  end
end