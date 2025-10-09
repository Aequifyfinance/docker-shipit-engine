threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Bind to all interfaces on port 3000 (plain HTTP)
bind "tcp://0.0.0.0:3000"

environment ENV.fetch("RAILS_ENV") { "production" }

workers ENV.fetch("WEB_CONCURRENCY") { 2 }
preload_app!

plugin :tmp_restart
