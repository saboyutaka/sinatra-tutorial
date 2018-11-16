require 'sinatra'
require 'sinatra/reloader'
require 'json'
json_path = File.dirname(__FILE__) + '/data/data.json'

set :public_folder, 'public'

enable :sessions

get '/' do
  erb :index
end

get '/hello' do
  'Hello World!'
end

get '/hello/:name' do
  name = ''
  @name = params[:name]
  erb :hello
end

get '/p' do
  params.to_s

  response = []

  if params[:name]
    response << "こんにちわ、 #{params[:name]}"
  end

  if params[:age]
    response << "#{params[:age]}歳なんですね"
  end

  if params[:address]
    response << "#{params[:address]}にお住まいですか"
  end

  response.join("<br>")
end

get '/form' do
  open(json_path) do |io|
    @data = JSON.load(io)
  end
  erb :form
end

post '/form' do
  filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("./public/image/#{filename}", 'wb') do |f|
    f.write(file.read)
  end

  datum = {
    "name" => params[:name],
    "email" => params[:email],
    "content" => params[:content],
    "image" => filename
  }

  data = []
  open(json_path) do |io|
    data = JSON.load(io)
  end
  data << datum
  open(json_path, 'w') do |io|
    JSON.dump(data, io)
  end

  redirect '/form'
end

get '/session' do
  @name = session[:name]
  erb :session_form
end

post '/session' do
  session[:name] = params[:name]

  redirect '/session'
end

get "/image" do
  erb :image_form
end

post '/image' do
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("./public/image/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end

  erb :image_show
end
