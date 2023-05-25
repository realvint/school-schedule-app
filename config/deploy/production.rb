server '188.120.224.38', user: 'deploy', roles: %w{app db web}

set :rails_env, 'production'
set :branch, 'master'
set :passenger_min_instances, 2
