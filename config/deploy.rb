require "bundler/vlad"

set :application, "illyan"
set :domain, "www-data@popper.sugarpond.net"
set :repository, "git@github.com:nbudin/illyan.git"
set :deploy_to, "/var/www/illyan"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :vlad do
  remote_task :copy_config_files, :roles => :app do
    run "cp #{shared_path}/config/* #{current_path}/config/"
  end
end

task "vlad:deploy" => %w[
  vlad:update vlad:bundle:install vlad:start_app vlad:cleanup
]