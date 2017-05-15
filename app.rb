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

# <img src="<%= @page.page_img.url %>">

end
