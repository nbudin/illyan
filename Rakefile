# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake'
require 'rake/testtask'
require 'rdoc/task'

begin
  require 'vlad'
  require 'vlad/git'
  Vlad.load :app => :passenger, :scm => :git
rescue LoadError
  puts "Warning: couldn't load vlad and vlad-git.  #{$!}"
end

Illyan::Application.load_tasks
