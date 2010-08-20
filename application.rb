require 'rubygems'
require 'pusher'
require 'haml'
require 'sinatra'

configure do
  Pusher.app_id = '1786'
  Pusher.key = '09435da909450e9b4b6e'
  Pusher.secret = '6112f12f27007eaab27d'

  APP_ID = Pusher.app_id
  API_KEY = Pusher.key
  SECRET = Pusher.secret
end

get '/' do
  haml(:index)
end

get '/push/:message' do
  @message = params[:message]
  Pusher['test_channel'].trigger('my_event', @message)
end
