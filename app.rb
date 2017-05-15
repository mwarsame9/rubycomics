require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'rubycomics'

if development?
  require 'sinatra/reloader'
  also_reload('**/*.rb')
end
class RubycomicsApp < Sinatra::Application

  def params
    super.symbolize
  end

  get('/') do
    erb(:index)
  end
end
