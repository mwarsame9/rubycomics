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

  get '/pages/new', auth: :user do
    erb :new_page
  end

  post '/pages/new', auth: :user do
    newpage = Rubycomics::Page.new user_id: current_user.id
    newpage.page_img = params.dig(:page_img, :tempfile)
    newpage.page_img_file_name = params.dig(:page_img, :filename)

    newpage.save
    redirect '/'
  end

  get '/pages/:id/edit', auth: :user do |id|
    @page = Rubycomics::Page.find(id)
    erb :page_edit
  end

  patch '/pages/:id', auth: :user do |id|
    page = Rubycomics::Page.find(id)
    page.user_id = current_user.id
    page.page_img = params.dig :page_img, :tempfile
    page.page_img_file_name = params.dig :page_img, :filename
    page.save
    redirect back
  end

  get '/pages/:id/delete', auth: :user do |id|
    Rubycomics::Page.delete(id)
    redirect '/'
  end

  get '/users/:id/delete', auth: :admin do |id|
    Rubycomics::User.delete(id)
    redirect '/users'
  end

  get '/pages/:id' do |id|
    @page = Rubycomics::Page.find(id)
    erb :page
  end

  get '/users', auth: :admin do
    @users = Rubycomics::User.all
    erb :users
  end

  get '/users/:id/edit', auth: :admin do |id|
    @user = Rubycomics::User.find(id)
    erb :user_edit
  end

  patch '/users/:id/edit', auth: :admin do |id|
    new_data = params.fetch(:user).delete_if {|key, value| value.blank? }
    Rubycomics::User.update id, new_data
    redirect back
  end

  post '/pages/:id/comments' do |id|
    new_comment = params.fetch(:comment)
    new_comment[:page_id] = p_id
    Rubycomics::Comment.create(new_comment)
    redirect '/pages/' + id
  end

  get '/pages/:p_id/comments/:c_id/delete', auth: :user do |p_id, c_id|
    Rubycomics::Comment.delete(c_id)
    redirect '/pages' + p_id
  end

  get '/login' do
    erb :login
  end


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
