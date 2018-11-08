require 'sinatra'
require 'sinatra/reloader'

set :public_folder, 'public'

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
  erb :form
end

post '/form' do
  @name = params[:name]
  @email = params[:email]
  @content = params[:content]
  erb :form_post
end
