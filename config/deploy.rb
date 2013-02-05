require "bundler/vlad"

set :application, "illyan"
set :user, "www-data"
set :domain, "#{user}@popper.sugarpond.net"
set :repository, "git://github.com/nbudin/illyan.git"
set :deploy_to, "/var/www/illyan"
set :rvm_cmd, nil #"source /etc/profile.d/rvm.sh"
set :bundle_cmd, [ rvm_cmd, "env $(cat #{shared_path}/config/production.env) bundle" ].compact.join(" && ")

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :vlad do
  remote_task :copy_config_files, :roles => :app do
    run "cp #{shared_path}/config/* #{current_path}/config/"
  end

  namespace :airbrake do
    remote_task :deploy, :roles => :app do
      run "cd #{release_path} && #{bundle_cmd} exec rake airbrake:deploy TO=production"
    end
  end
end

task "vlad:deploy" => %w[
  vlad:update vlad:bundle:install vlad:copy_config_files vlad:airbrake:deploy deploy:restart vlad:cleanup
]
