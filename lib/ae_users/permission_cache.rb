module AeUsers
  class PermissionCache
    def initialize
      @cache = {}
    end

    def permitted?(person, permissioned, permission)
      RAILS_DEFAULT_LOGGER.debug "Permission cache looking up result for #{person}, #{permissioned}, #{permission}"
      pcache = person_cache(person)
      key = pcache_key(permissioned, permission)
      unless pcache.has_key?(key)
        RAILS_DEFAULT_LOGGER.debug "Cache miss!  Loading uncached permission."
        pcache[key] = person.uncached_permitted?(permissioned, permission)
      end
      RAILS_DEFAULT_LOGGER.debug "Result is #{pcache[key]}"
      return pcache[key]
    end

    def invalidate(person, permissioned, permission)
      RAILS_DEFAULT_LOGGER.debug "Permission cache invalidating result for #{person}, #{permissioned}, #{permission}"
      pcache = person_cache(person)
      pcache.delete(pcache_key(permissioned, permission))
    end

    def invalidate_all(options={})
      if options[:person]
        RAILS_DEFAULT_LOGGER.debug "Permission cache invalidating all results for #{options[:person]}"
        @cache.delete(options[:person])
      elsif options[:permission] and options[:permissioned]
        RAILS_DEFAULT_LOGGER.debug "Permission cache invalidating all results for #{options[:permissioned]}, #{options[:permission]}"
        @cache.each_value do |pcache|
          pcache.delete(pcache_key(options[:permissioned], options[:permission]))
        end
      else
        RAILS_DEFAULT_LOGGER.debug "Permission cache invalidating all results!"
        @cache = {}
      end
    end

    private
    def person_cache(person)
      unless @cache.has_key?(person)
        RAILS_DEFAULT_LOGGER.debug "Permission cache creating new pcache for #{person}"
        @cache[person] = {}
      end
      @cache[person]
    end

    def pcache_key(permissioned, permission)
      if permissioned
        return "#{permissioned.id}_#{permission}"
      else
        return "nil_#{permission}"
      end
    end
  end
end