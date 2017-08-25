require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'vlogerok.db'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "Posts" 
		("id" INTEGER PRIMARY KEY AUTOINCREMENT,
		 "createddate" DATE,
		 "details" TEXT ) '
	db.execute 'CREATE TABLE IF NOT EXISTS "Comments"
		("id" INTEGER PRIMARY KEY AUTOINCREMENT,
		 "createddate" DATE,
		 "comment" TEXT )'
end

get '/' do
	erb "Hello!"
end

get '/new' do
  	erb :new
end

post '/new' do
  	@content = params[:content]

end