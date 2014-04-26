require "bundler/capistrano"
require 'new_relic/recipes'

set :application, "jiff"
set :scm, "git"
set :repository, "git@github.com:JIFFinc/jiff-com.git"
set :branch, fetch(:branch, "master")
set :env, fetch(:env, "production")
set :deploy_to, '/home/ooga/rails'
set :keep_releases, 3
#set :git_shallow_clone, 1
set :deploy_via, :remote_cache
set :use_sudo,  false

begin; default_run_options[:pty] = true; rescue; end

set :scm_username, "git"
set :user, "ooga"

task :staging do
  set :port, 22
  set :deploy_to, 	'/home/ooga/www'
  set :rails_env,       "production"
  role :web,            "www-stage.jiff.com", :primary => true
  role :app,            "www-stage.jiff.com", :primary => true
  role :db,             "www-stage.jiff.com", :primary => true
end

task :production do
  set :port, 9722
  set :rails_env,       "production"
  role :web,            "www.jiff.com", :primary => true
  role :app,            "www.jiff.com", :primary => true
  role :db,             "www.jiff.com", :primary => true
end


# Override some methods for custom logic
namespace :deploy do

  namespace :web do
    task :disable, :roles => :web, :except => { :no_release => true } do
      on_rollback { delete "#{shared_path}/system/maintenance.html"}
      run "cp #{release_path}/public/503.html #{shared_path}/system/maintenance.html"
    end

    task :enable, :roles => :web, :except => { :no_release => true } do
      run "rm -f #{shared_path}/system/maintenance.html"
    end
  end

  task :finalize_update, :except => { :no_release => true } do
    run <<-CMD
      rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp &&
      mkdir -p #{latest_release}/public &&
      mkdir -p #{shared_path}/tmp/pids &&
      ln -nfs #{shared_path}/tmp #{latest_release}/tmp &&
      ln -nfs #{shared_path}/system #{latest_release}/public/system
    CMD
    run "rm -f #{latest_release}/config/database.yml && ln -s #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
    run "git ls-remote git@github.com:JIFFinc/jiff-com.git #{branch} >> #{release_path}/public/VERSION"
  end

  task :symlink_logs do
    run "rm -rf #{current_path}/log && ln -nfs #{shared_path}/log #{current_path}/log"
  end

  task :migrate, :roles => :db do
  end

  task :restart do
    #do nothing
  end

  task :restart_passenger, :roles => :app, :except => { :no_release => true }  do
      run "touch #{deploy_to}/shared/passenger-restart/restart.txt"
      run "touch #{deploy_to}/shared/tmp/restart.txt"
  end

  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
#	run "cd #{latest_release} ; bundle exec rake RAILS_ENV=production RAILS_GROUPS=assets assets:precompile"
    end
  end

end

namespace :bundle do
  task :install, :roles => [ :web, :app ], :except => { :no_release => true } do
    run "cd #{latest_release} && bundle install --gemfile #{latest_release}/Gemfile --path #{shared_path}/bundle --deployment --quiet --without development test"
  end
end

desc "Rake task raketask=<task name> rake_params=<rake_params>"
task :rake_task, :roles => :app do
  if respond_to? :raketask
    set :r_task, "#{raketask}"
  else
    set :r_task, "airbrake:test"
  end

  if respond_to? :rake_params
    set :r_params, "#{rake_params}"
  else
    set :r_params, ""
  end

  puts "Running task #{r_task} #{r_params}"
  run <<-CMD
    cd #{deploy_to}/current &&
    RAILS_ENV=#{rails_env} bundle exec rake #{r_task} #{r_params}
  CMD
end

task :complete do
  begin
    raise if ENV["SHUTUP_CAPISTRANO"]
    `say "deploy complete"`
  rescue Exception => e
    `say "I've just picked up a fault in the AE35 unit. It's going to go 100% failure in 72 hours"`
    puts "#{e} ... (ignoring)"
  end
  puts ">>>>>> DONE DEPLOYING <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
end


after "deploy:update_code", "deploy:web:disable"
after 'deploy:update_code', 'deploy:cleanup'

after 'deploy:symlink', 'deploy:symlink_logs'
#after 'deploy:symlink_logs', 'deploy:assets:precompile'
after 'deploy:symlink_logs', 'deploy:restart_passenger'
after 'deploy:restart_passenger', 'deploy:web:enable'
after 'deploy:web:enable', 'complete'

require './config/boot'
