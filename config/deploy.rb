require "bundler/vlad"

set :application, "illyan"
set :user, "www-data"
set :domain, "#{user}@popper.sugarpond.net"
set :repository, "git://github.com/nbudin/illyan.git"
set :revision, "origin/master"
set :deploy_to, "/var/www/illyan"
set :rvm_cmd, nil #"source /etc/profile.d/rvm.sh"
set :bundle_cmd, [ rvm_cmd, "env $(cat #{shared_path}/config/production.env) bundle" ].compact.join(" && ")
set :rake_cmd, "#{bundle_cmd} exec rake"

namespace :vlad do
  remote_task :copy_config_files, :roles => :app do
    run "cp #{shared_path}/config/* #{current_path}/config/"
  end

  namespace :airbrake do
    remote_task :deploy, :roles => :app do
      run "cd #{release_path} && #{rake_cmd} airbrake:deploy TO=production"
    end
  end
end

task "vlad:deploy" => %w[
  vlad:update vlad:bundle:install vlad:copy_config_files vlad:assets:precompile vlad:migrate vlad:airbrake:deploy vlad:start_app vlad:cleanup
]
