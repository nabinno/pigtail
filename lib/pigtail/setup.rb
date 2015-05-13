# Environment variable defaults to RAILS_ENV
set :environment_variable, "RAILS_ENV"
# Environment defaults to production
set :environment, "production"
# Path defaults to the directory `pigtail` was run from
set :path, Pigtail.path

# All configs are wrapped in this template.
set :config_template, ":config"

config_type :command, ":task"
