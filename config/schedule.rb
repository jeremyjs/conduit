set :output, "log/cron_log.log"
set :environment, 'development'

job_type :rbenv_rake, %Q{eval "$(rbenv init -)"; \
                         cd :path && bundle install --quiet &&  bundle exec rake :task :output }

every 15.minutes do
  rbenv_rake "conduit:execute_queries"
end
