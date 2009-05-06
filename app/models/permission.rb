class Permission < ActiveRecord::Base
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
  
  def cache_conds
    cond_sql = "permission_name = ?"
    cond_objs = [permission]
    if person
      cond_sql += " and person_id = ?"
      cond_objs += [person.id]
    end
    if permissioned
      cond_sql += " and permissioned_type = ? and permissioned_id = ?"
      cond_objs += [permissioned.class.name, permissioned.id]
    end
    return [cond_sql] + cond_objs
  end

  def destroy_caches_for_person(p)
    if AeUsers.cache_permissions?
      if permissioned and permission
        AeUsers.permission_cache.invalidate(p, permissioned, permission)
      else
        AeUsers.permission_cache.invalidate_all(:person => p)
      end
    end
  end
  
  def destroy_caches
    if AeUsers.cache_permissions?
      if person
        destroy_caches_for_person(person)
      elsif role
        role.members.each do |person|
          AeUsers.permission_cache.invalidate(person, permissioned, permission)
        end
      elsif permissioned and permission
        AeUsers.permission_cache.invalidate_all(:permissioned => permissioned, :permission => permission)
      else
        AeUsers.permission_cache.invalidate_all
      end
    end
  end
end
