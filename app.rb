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

  get_db.execute 'CREATE TABLE IF NOT EXISTS "comments"
  (
  "id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL UNIQUE,
  "created_at" DATETIME NOT NULL,
  "content" TEXT NOT NULL ,
  "fk_post" INTEGER NOT NULL
  )'

end

get '/' do
  @posts = @db.execute 'select * from posts order by id desc'
  erb :index
end

get '/new_post' do
  erb :new_post
end

post '/new_post' do
  @posts = @db.execute 'select * from posts order by id desc'
  @post_name = params[:post_name]
  @post_text = params[:post_text]
  get_db.execute 'INSERT INTO posts 
        (created_at, 
        name, 
        content) 
  VALUES
        (datetime(),
        ?,
        ?)',[@post_name, @post_text]
  erb :index
end

get '/details/:id' do
  id = params[:id]
  post = @db.execute 'select * from posts where id = ?', [id]
  @row = post[0]
  @comments = @db.execute 'select * from comments where fk_post = ? order by id desc', [id]
  erb :details_post
end

# details for comment
post '/details/:id' do
  post_id = params[:id]
  content = params[:comment_text]
  get_db.execute 'INSERT INTO comments 
      (created_at, 
      content, 
      fk_post) 
  VALUES
      (datetime(),
      ?, 
      ?)', [content, post_id]
  redirect to("/details/#{post_id}")
end