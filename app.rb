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
		 username TEXT,
		 created_date DATE,
		 details TEXT ) '
	@db.execute 'CREATE TABLE IF NOT EXISTS Comments
		(id INTEGER PRIMARY KEY AUTOINCREMENT,
		 created_date DATE,
		 comment TEXT,
		 post_id INTEGER ) '
end

get '/' do
	@post_list = @db.execute 'select * from Posts order by id desc'
	erb :index
end

get '/new' do
  	erb :new
end

post '/new' do
  	@username = params[:username]
  	@content = params[:content]

  	@db.execute 'insert into Posts (username, details, created_date)
				values ( ?, ?, datetime())', [@username, @content]

	hh = { 	:username => 'Enter your Name',
			:content => 'Enter post content' }
	@error = hh.select {|key,_| params[key] == ""}.values.join(". ")
	if @error != ''
		return erb :new
	end
	#if @content.length < 1
	#	@error = 'Type post text'
	#	return erb :new
	#end	

	redirect to('/')	
end

get '/post-:post_id' do
	post_id = params[:post_id]

	post_details = @db.execute 'select * from Posts where id = ?', [post_id]
	@row = post_details[0]
	@comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]
	erb :post

end

post '/post-:post_id' do
	post_id = params[:post_id]
	content = params[:content]

	@db.execute 'insert into Comments (comment, created_date, post_id)
				values ( ?, datetime(), ?)', [content, post_id]

	#if content.length < 1
	#	@error = 'Type comment'
	#	return erb :post
	#end	

	redirect to('/post-' + post_id)
end