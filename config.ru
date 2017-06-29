# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# config.middleware.use Rack::Auth::Basic do |username, password|
#   username == "YOUR_NAME" && password == "PASSWORD"
# end
use Rack::Auth::Basic do |username, password|
  username == ENV['AUTH_USERNAME'] && password == ENV['AUTH_PASSWORD']
end if ENV['AUTH_USERNAME'] && ENV['AUTH_PASSWORD']
run Rails.application
