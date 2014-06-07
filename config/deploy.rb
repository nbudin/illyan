require "bundler/capistrano"
require "capistrano-rbenv"
require "airbrake/capistrano"

load "deploy/assets"

role :web, 'hempel.sugarpond.net', primary: true
role :app, 'hempel.sugarpond.net', primary: true
role :db, 'hempel.sugarpond.net', primary: true
#chef_role [:web, :app], 'roles:app_server AND chef_environment:production'
#chef_role :db, 'roles:mysql_server AND chef_environment:production', primary: true
set :user, 'deploy'

#role :web, 'localhost'
#set :user, 'www-data'
#set :ssh_options, {port: 2222, keys: ['~/.ssh/id_dsa']}

set :rbenv_path, "/opt/rbenv"
set :rbenv_setup_shell, false
set :rbenv_setup_default_environment, false
set :rbenv_setup_global_version, false
set :rbenv_ruby_version, "2.1.2"

set :application, "illyan"
set :repository, "git://github.com/nbudin/illyan.git"
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false

set :scm, :git
set :bundle_without, [:development, :test]

namespace(:deploy) do
  desc "Link in config files needed for environment"
  task :symlink_config, :roles => :app do
    run "ln -nfs #{shared_path}/config/* #{release_path}/config/"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

before "deploy:finalize_update", "deploy:symlink_config"
after "deploy", "deploy:cleanup"
