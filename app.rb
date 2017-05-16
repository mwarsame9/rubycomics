require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'rubycomics'

if development?
  require 'sinatra/reloader'
  also_reload('**/*.rb')
end

Paperclip::Attachment.default_options[:path] = Dir.pwd + '/public:url'
Paperclip::Attachment.default_options[:url] = "/uploads/:attachment/:filename"

class RubycomicsApp < Sinatra::Application
  enable :sessions

  register do
    def auth (type)
      condition do
        redirect "/login" unless send("#{type}?")
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
    pagedata = params.fetch :page
    newpage = Rubycomics::Page.new(pagedata)
    newpage.page_img = params.dig(:page_img, :tempfile)
    newpage.page_img_file_name = params.dig(:page_img, :filename)

    newpage.save
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

end
