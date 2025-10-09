threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Bind to all interfaces on port 3000 (plain HTTP)
bind "tcp://0.0.0.0:3000"

environment ENV.fetch("RAILS_ENV") { "development" }

workers 0
preload_app! false

plugin :tmp_restart