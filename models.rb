# require "sinatra"
require "data_mapper"
DataMapper.setup :default, "sqlite3://#{Dir.pwd}/assignment3.db"

class User
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String  , required:true
  property :email,        Text    , required:true
  property :password,     String  , required:true
  property :created_at,   DateTime
end

class Student
  include DataMapper::Resource
  property :id,           Serial
  property :firstname,    String  , required:true
  property :lastname,     String  , required:true
  property :birthday,     Date    , required:true
  property :address,      Text
  property :student_id,   Integer , required:true
  property :info,         Text

end

class Comment
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String  , required:true
  property :content,        Text  , required:true
  property :created_at,   DateTime
end


DataMapper.auto_upgrade!
