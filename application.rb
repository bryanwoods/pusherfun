require 'rubygems'
require 'pusher'
require 'mongo_mapper'
require 'haml'
require 'sinatra'

configure do
  environment = Sinatra::Application.environment

  if ENV['MONGOHQ_URL']
    MongoMapper.config = {environment => {'uri' => ENV['MONGOHQ_URL']}}
  else
    MongoMapper.config = {environment => {'uri' => 'mongodb://localhost/development'}}
  end

  MongoMapper.connect(environment)

  Pusher.app_id = '1786'
  Pusher.key = '09435da909450e9b4b6e'
  Pusher.secret = '6112f12f27007eaab27d'

  APP_ID = Pusher.app_id
  API_KEY = Pusher.key
  SECRET = Pusher.secret
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

class Message
  include MongoMapper::Document
  key :screen_name, String, :required => true
  key :message, String, :required => true
  timestamps!
end

get '/' do
  @messages = Message.all
  haml(:index)
end

post '/messages/?' do
  @screen_name = params[:screen_name]
  @message = params[:message]
  Pusher['test_channel'].trigger('my_event', "<b>#{h(@screen_name)}</b>: #{h(@message)}")
  message = Message.create({:screen_name => @screen_name, :message => @message})
  message.save
end
