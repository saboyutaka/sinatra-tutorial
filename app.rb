require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'mysql2'

json_path = File.dirname(__FILE__) + '/data/data.json'

def db
  @db ||= Mysql2::Client.new(
    host:     ENV['DB_HOST'] || 'localhost',
    port:     ENV['DB_PORT'] || '3306',
    username: ENV['DB_USERNAME'] || 'root',
    password: ENV['DB_PASSWORD'] || '',
    database: ENV['DB_DATABASE'] || 'tutorial',
  )
end

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

get "/posts" do
  sql = "SELECT * FROM posts"
  @posts = db.query(sql).to_a

  erb :posts
end

post "/posts" do
  title = params[:title]
  filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("./public/image/#{filename}", 'wb') do |f|
    f.write(file.read)
  end

  sql = "INSERT INTO `posts` (`title`, `image`, `created_at`) VALUES ('#{title}', '#{filename}', NOW());"
  db.query(sql)

  @posts = db.query("SELECT * FROM posts").to_a

  redirect '/posts'
end


get '/session' do
  @name = session[:name]
  erb :session_form
end

post '/session' do
  session[:name] = params[:name]

  redirect '/session'
end

get '/login' do
  @name = session[:login]
  @message = session[:message]
  session[:message] = nil
  erb :login_form
end

post '/login' do
  if params[:name] == 'sabo' && params[:password] == 'codebase'
    session[:login] = 'さぼ'
    session[:message] = 'ログインしました'
  else
    session[:message] = 'ログイン失敗しました'
  end

  redirect '/login'
end

get '/logout' do
  session[:login] = nil
  redirect '/login'
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
