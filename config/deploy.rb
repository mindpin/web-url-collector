require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

set :domain, '106.186.119.248'
set :deploy_to, '/web/web-url-collector'
set :current_path, 'current'
set :repository, 'git://github.com/mindpin/web-url-collector.git'
set :branch, 'master'
set :user, 'root'

set :shared_paths, [
  'config/mongoid.yml',
  'config/env.yml',
  'config/secrets.yml',
  'tmp',
  'log',
  'config/initializers/r.rb',
  'config/initializers/weibo_oauth2.rb'
]

task :environment do
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/logs"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/logs"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]
  queue! %[touch "#{deploy_to}/shared/config/mongoid.yml"]
  queue! %[touch "#{deploy_to}/shared/config/env.yml"]
  queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
  
  queue! %[mkdir -p "#{deploy_to}/shared/config/initializers"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config/initializers"]
  queue! %[touch "#{deploy_to}/shared/config/initializers/r.rb"]
  queue! %[touch "#{deploy_to}/shared/config/initializers/weibo_oauth2.rb"]

  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue  %[echo "-----> Be sure to edit 'shared/config/mongoid.yml'."]
  queue  %[echo "-----> Be sure to edit 'shared/config/env.yml'."]
  queue  %[echo "-----> Be sure to edit 'shared/config/secrets.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    queue! "bundle"
    invoke :'rails:assets_precompile'

    to :launch do
      queue %[
        source /etc/profile
        ./deploy/sh/unicorn.sh stop
        ./deploy/sh/unicorn.sh start
      ]
    end
  end
end

desc "update code only"
task :update_code => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    queue! "bundle"
    invoke :'rails:assets_precompile'
  end
end

desc "restart server"
task :restart => :environment do
  queue %[
    source /etc/profile
    cd #{deploy_to}/#{current_path}
    ./deploy/sh/unicorn.sh stop
    ./deploy/sh/unicorn.sh start
  ]
end

