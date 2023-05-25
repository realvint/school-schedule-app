lock "~> 3.17.1"

set :application, 'school_app'
set :repo_url, 'git@github.com:realvint/school-schedule-app.git'
set :branch, 'master'
set :deploy_to, -> { "/home/deploy/projects/#{fetch(:application)}" }
set :deploy_via, :remote_cache
set :log_level, :info
set :pty, false
set :bundle_flags, ''
set :bundle_jobs, 1
set :linked_files, %w[config/database.yml config/master.key]
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads node_modules vendor storage]
set :assets_dir, 'storage'
set :local_assets_dir, '.'
set :user, 'deploy'
set :keep_releases, 2
set :rbenv_type, :user
set :rbenv_ruby, '3.2.2'
set :nvm_type, :user
set :nvm_node, 'v16.19.0'
set :nvm_map_bins, %w[node npm yarn rake rails]
set :ssh_options, forward_agent: false

set :default_env, {
  'PATH' => "/home/deploy/.nvm/versions/node/#{fetch(:nvm_node)}/bin:$PATH",
  'RAILS_SERVE_STATIC_FILES' => true
}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end

Rake::Task['deploy:assets:backup_manifest'].clear_actions
