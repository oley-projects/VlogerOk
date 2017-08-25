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
		 createddate DATE,
		 details TEXT ) '
	@db.execute 'CREATE TABLE IF NOT EXISTS Comments
		(id INTEGER PRIMARY KEY AUTOINCREMENT,
		 createddate DATE,
		 comment TEXT ) '
end

get '/' do
	erb "Hello!"
end

get '/new' do
  	erb :new
end

post '/new' do
  	content = params[:content]

  	@db.execute 'insert into Posts (details, createddate)
				values ( ?, datetime())', [content]

	if content.length < 1
		@error = 'Type post text'
		return erb :new
	end		
end