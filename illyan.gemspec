# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{illyan}
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nat Budin"]
  s.date = %q{2009-11-24}
  s.description = %q{Illyan is an out-of-the-box setup for authentication, authorization, and (optionally)
single sign-on.  Rather than reinventing the wheel, Illyan uses popular and proven
solutions: Authlogic for authentication, acl9 for authorization, and CAS for single
sign-on.
}
  s.email = %q{natbudin@gmail.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "README",
     "Rakefile",
     "VERSION",
     "ae_users.gemspec",
     "app/controllers/account_controller.rb",
     "app/controllers/auth_controller.rb",
     "app/controllers/permission_controller.rb",
     "app/helpers/account_helper.rb",
     "app/helpers/ae_users_helper.rb",
     "app/helpers/auth_helper.rb",
     "app/helpers/permission_helper.rb",
     "app/models/account.rb",
     "app/models/auth_notifier.rb",
     "app/models/auth_ticket.rb",
     "app/models/email_address.rb",
     "app/models/group.rb",
     "app/models/login.rb",
     "app/models/open_id_identity.rb",
     "app/models/person.rb",
     "app/models/role.rb",
     "app/views/account/_personal_info.rhtml",
     "app/views/account/_procon_profile.rhtml",
     "app/views/account/_signup_form.html.erb",
     "app/views/account/activate.rhtml",
     "app/views/account/activation_error.rhtml",
     "app/views/account/change_password.rhtml",
     "app/views/account/edit_profile.rhtml",
     "app/views/account/signup.rhtml",
     "app/views/account/signup_noactivation.rhtml",
     "app/views/account/signup_success.rhtml",
     "app/views/auth/_auth_form.rhtml",
     "app/views/auth/_forgot_form.html.erb",
     "app/views/auth/_mini_auth_form.rhtml",
     "app/views/auth/_openid_auth_form.html.erb",
     "app/views/auth/_other_login_options.html.erb",
     "app/views/auth/auth_form.js.erb",
     "app/views/auth/forgot.rhtml",
     "app/views/auth/forgot_form.rhtml",
     "app/views/auth/index.css.erb",
     "app/views/auth/login.rhtml",
     "app/views/auth/needs_activation.rhtml",
     "app/views/auth/needs_person.html.erb",
     "app/views/auth/needs_profile.rhtml",
     "app/views/auth/openid_login.html.erb",
     "app/views/auth/resend_activation.rhtml",
     "app/views/auth_notifier/account_activation.rhtml",
     "app/views/auth_notifier/generated_password.rhtml",
     "app/views/permission/_add_grantee.rhtml",
     "app/views/permission/_role.html.erb",
     "app/views/permission/_show.rhtml",
     "app/views/permission/grant.rhtml",
     "db/migrate/002_create_accounts.rb",
     "db/migrate/003_create_email_addresses.rb",
     "db/migrate/004_create_people.rb",
     "db/migrate/013_simplify_signup.rb",
     "db/migrate/014_create_permissions.rb",
     "db/migrate/015_create_roles.rb",
     "db/migrate/016_refactor_people.rb",
     "db/migrate/017_people_permissions.rb",
     "db/migrate/018_roles_to_groups.rb",
     "generators/ae_users/USAGE",
     "generators/ae_users/ae_users_generator.rb",
     "generators/ae_users/templates/add.png",
     "generators/ae_users/templates/admin.png",
     "generators/ae_users/templates/group.png",
     "generators/ae_users/templates/logout.png",
     "generators/ae_users/templates/migration.rb",
     "generators/ae_users/templates/openid.gif",
     "generators/ae_users/templates/remove.png",
     "generators/ae_users/templates/user.png",
     "generators/ae_users_acl9_migration/USAGE",
     "generators/ae_users_acl9_migration/ae_users_acl9_migration_generator.rb",
     "generators/ae_users_acl9_migration/templates/migrate_to_acl9.rb",
     "init.rb",
     "install.rb",
     "lib/ae_users.rb",
     "lib/ae_users/acts.rb",
     "lib/ae_users/acts/shared_model.rb",
     "lib/ae_users/controller_extensions.rb",
     "lib/ae_users/form_builder_extensions.rb",
     "lib/ae_users/instance_tag_extensions.rb",
     "lib/ae_users/model_extensions.rb",
     "migrate_from_shared_database.sh",
     "rails/init.rb",
     "rails/tasks/ae_users_tasks.rake",
     "test/ae_users_test.rb",
     "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/nbudin/ae_users}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Instant authentication, authorization, and SSO for Rails}
  s.test_files = [
    "test/ae_users_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<acl9>, [">= 0"])
      s.add_runtime_dependency(%q<authlogic>, [">= 0"])
    else
      s.add_dependency(%q<acl9>, [">= 0"])
      s.add_dependency(%q<authlogic>, [">= 0"])
    end
  else
    s.add_dependency(%q<acl9>, [">= 0"])
    s.add_dependency(%q<authlogic>, [">= 0"])
  end
end