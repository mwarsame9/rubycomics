require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'rubycomics'

if development?
  require 'sinatra/reloader'
  also_reload('**/*.rb')
end

Paperclip::Attachment.default_options[:path] = Dir.pwd + '/public:url'
Paperclip::Attachment.default_options[:url] = '/uploads/:attachment/:filename'

class RubycomicsApp < Sinatra::Application
  use Rack::Session::Cookie, :key => 'rack.session',
                             :path => '/',
                             :secret => 'ivegottasecret'

  register do
    def auth(type)
      condition do
        redirect '/login' unless send("#{type}?")
      end
    end
  end

  def params
    super.symbolize
  end

  get('/') do
    @pages = Rubycomics::Page.all
    erb(:index)
  end

  get '/pages/new' do
    erb :new_page
  end

  post '/pages/new' do
    newpage = Rubycomics::Page.new user_id: current_user.id
    newpage.page_img = params.dig(:page_img, :tempfile)
    newpage.page_img_file_name = params.dig(:page_img, :filename)

    newpage.save
    redirect '/'
  end

  get '/pages/:id/edit' do |id|
    @page = Rubycomics::Page.find(id)
    erb :page_edit
  end

  patch '/pages/:id' do |id|
    page = Rubycomics::Page.find(id)
    page.user_id = current_user.id
    page.page_img = params.dig :page_img, :tempfile
    page.page_img_file_name = params.dig :page_img, :filename
    page.save
    redirect back
  end

  get '/pages/:id/delete' do |id|
    Rubycomics::Page.delete(id)
    redirect '/'
  end

  get '/pages/:id' do |id|
    @page = Rubycomics::Page.find(id)
    erb :page
  end

  get '/login' do
    erb :login
  end
  # <img src="<%= @page.page_img.url %>">

  post('/login') do
    login_info = params.fetch(:login_info)
    login(login_info)
  end

  get('/logout', auth: :user) do
    logout
  end

  post('/signup') do
    signup(params.fetch(:signup))
  end
end

require_relative 'helpers/authinabox'
