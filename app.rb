require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'vlogerok.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts
		(id INTEGER PRIMARY KEY AUTOINCREMENT,
		 created_date DATE,
		 details TEXT ) '
	@db.execute 'CREATE TABLE IF NOT EXISTS Comments
		(id INTEGER PRIMARY KEY AUTOINCREMENT,
		 created_date DATE,
		 comment TEXT,
		 post_id INTEGER) '
end

get '/' do
	@post_list = @db.execute 'select * from Posts order by id desc'
	erb :index
end

get '/new' do
  	erb :new
end

post '/new' do
  	content = params[:content]

  	@db.execute 'insert into Posts (details, created_date)
				values ( ?, datetime())', [content]

	if content.length < 1
		@error = 'Type post text'
		return erb :new
	end	

	redirect to('/')	
end

get '/post-:post_id' do
	post_id = params[:post_id]
	post_details = @db.execute 'select * from Posts where id = ?', [post_id]
	@row = post_details[0]
	erb :post
end