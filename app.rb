require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra-flash'

if development?
  require 'sinatra/reloader'
  also_reload('**/*.rb')
end

get('/') do
  erb(:index)
end
