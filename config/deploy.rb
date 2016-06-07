require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)
App = 'scoresystem'
Srv = {
  'root' => '192.168.1.20'
}
server = ENV['server'] || 'test'

set :domain, Srv[server]
set :deploy_to, "/var/nginx/#{App}"
set :repository, "https://github.com/TonyWong20160510/ScoringSystem"
set :branch, 'master'
# set :term_mode, :system
# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml',  'config/application.yml', 'log', 'tmp/sockets', 'tmp/pids', 'public/uploads']  #['config/database.yml', 'log']

# Optional settings:
set :user, 'root'    # Username in the server to SSH to.
set :identity_file, '~/.ssh/tmp_convert'
#set :port, '22222'     # SSH port number.
set :rvm_path, '/etc/profile.d/rvm.sh'
# set :rvm_path, '/home/tcgo/.rvm/scripts/rvm'
# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby-2.0.0-p247@rails32]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  # 在服务器项目目录的shared中创建log文件夹
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]
 # 在服务器项目目录的shared中创建config文件夹 下同
  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> 请编辑 'shared/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    puts "执行git:clone"
    invoke :'deploy:link_shared_paths'
    puts "执行deploy:link_shared_paths"
    invoke :'bundle:install'
    puts "执行bundle:install"
    # invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    puts "执行rails:assets_precompile"
    invoke :"deploy:cleanup"
    puts "执行deploy:cleanup"

    to :launch do
      # puts "重启scoresystem项目"
      # queue "touch #{deploy_to}/tmp/restart.txt"
      # invoke 'service:restart'
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      # queue "chown -R www-data #{deploy_to}"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

