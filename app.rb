require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb 'Hello'
end

get '/posts' do
  erb "Hello World"
end

get '/new_post' do
  erb :new_post
end

post '/new' do
  @post_name = params[:post_name]
  @post_text = params[:post_text]
  erb "post #{@post_name} post_text #{@post_text}"
end