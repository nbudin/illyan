module AeUsers
  module FormBuilderExtensions
    def person_field(method, options = {})
      @template.send("person_field", @object_name, method, objectify_options(options))
    end
  end
end