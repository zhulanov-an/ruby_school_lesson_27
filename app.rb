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
  erb "Hello World"
end