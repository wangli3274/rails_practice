# Sidekiq.configure_server do |config|
#   config.redis = { :url => "redis://#{$g_config[:redis_host]}:#{$g_config[:redis_port]}/#{$g_config[:redis_db]}", :namespace => 'ASYNC::QUEUE' }
# end

# Sidekiq.configure_client do |config|
#   config.redis = { :url => "redis://#{$g_config[:redis_host]}:#{$g_config[:redis_port]}/#{$g_config[:redis_db]}", :namespace => 'ASYNC::QUEUE' }
# end

# Sidekiq::Web.use Rack::Auth::Basic do |username, password|
#   username == 'wangli' && password == 'eve'
# end 

# Sidekiq::Logging.logger = Rails.logger
# Sidekiq::Logging.logger.level = Rails.logger.level

Sidekiq.configure_server do |config|
  config.redis = { :url => 'redis://127.0.0.1:6379/12'}
end

Sidekiq.configure_client do |config|
  config.redis = { :url => 'redis://127.0.0.1:6379/12'}
end