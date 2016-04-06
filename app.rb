require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
  db = SQLite3::Database.new './database/leprosorium.sqlite'
  db.results_as_hash = true
  db
end

before do
  @db = get_db
end

configure do
  get_db.execute 'CREATE TABLE IF NOT EXISTS "posts"
  (
  "id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL UNIQUE,
  "created_at" DATETIME NOT NULL,
  "name" TEXT NOT NULL,
  "content" TEXT NOT NULL 
  )'
end

get '/' do
  erb :posts
end

get '/posts' do
  erb :posts
end

get '/new_post' do
  erb :new_post
end

post '/new' do
  @post_name = params[:post_name]
  @post_text = params[:post_text]
  get_db.execute 'INSERT INTO posts (created_at, name, content) VALUES(datetime(), ?, ?)',[@post_name, @post_text]
  erb :new_post
end