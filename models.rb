# require "sinatra"
require "data_mapper"
# DataMapper.setup :default, "sqlite3://#{Dir.pwd}/assignment3.db"
DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

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
  property :name,         String

  property :address,      Text
  property :student_id,   Integer , required:true, unique:true
  property :extrainfo,    Text, default: "No extra information available"
  property :created_at,   DateTime

  property :birthday_day, String
  property :birthday_month, String
  property :birthday_year, String
  property :birthday, Date

  before :save do
    self.birthday = Date.new(birthday_year.to_i, birthday_month.to_i, birthday_day.to_i)
    self.name = firstname + " " + lastname
  end

end

class Comment
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String  , required:true
  property :content,        Text  , required:true
  property :created_at,   DateTime
end


DataMapper.auto_upgrade!
