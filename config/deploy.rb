require "mina/bundler"
require "mina/rails"
require "mina/git"

set :repository, "ssh://git@github.com/dillonhafer/hr-til.git"
set :domain, "hr_til_production" # create your own SSH alias
set :deploy_to, "/var/www/hr-til-production"
set :branch, "master"
set :rails_env, "production"
set :keep_releases, 4
set :forward_agent, true

set :shared_dirs, fetch(:shared_dirs, []).concat(%w[
  log
  node_modules
  tmp/pids
  tmp/cache
  public/assets
])

set :shared_files, fetch(:shared_files, []).concat(%w[
  public/masthead.png
  public/favicon.png
])

task :remote_environment do
  command "export $(cat /var/www/hr-til-production/shared/.env | xargs)"
  command "export PATH=/root/.asdf/shims:$PATH"
end

desc "Deploys the App."
task deploy: :remote_environment do
  deploy do
    invoke :"git:clone"
    invoke :"deploy:link_shared_paths"
    invoke :"bundle:install"
    invoke :"rails:db_migrate"
    invoke :"rails:assets_precompile"
    invoke :"deploy:cleanup"

    on :launch do
      in_path(fetch(:current_path)) do
        invoke :"puma:restart"
      end
    end
  end
end

namespace :puma do
  task :restart do
    comment "Restarting puma"
    command "sudo service puma restart"
  end
end
