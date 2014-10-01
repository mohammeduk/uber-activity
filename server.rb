require 'rubygems'
require 'bundler'

Bundler.require
Dotenv.load

require 'sinatra/base'
require 'sinatra/reloader'

require 'helpers'

class UberActivity < Sinatra::Base
  use Rack::Session::Cookie
  use Rack::Flash
  use OmniAuth::Builder do
    provider :uber, ENV['UBER_CLIENT_ID'], ENV['UBER_CLIENT_SECRET']
  end

  configure :development do
    register Sinatra::Reloader
  end

  helpers Uber::Helpers

  get '/' do
    redirect to('/login') unless authorized?
    erb :index
  end

  get '/login' do
    erb :login
  end

  get '/auth/:provider/callback' do
    omniauth = request.env['omniauth.auth']
    login!(omniauth)
    flash[:notice] = "Welcome back!"
    redirect to("/")
  end

  get "/logout" do
    logout!
    flash[:notice] = "You've been logged out."
    redirect to("/")
  end
end
