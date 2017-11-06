# app.rb
require "sinatra"
require "sinatra/activerecord"
require "./models.rb"

set :database, "sqlite3:assignment3db.sqlite3"
enable :sessions


# index page
get '/' do
	erb :index
end




# about page
get '/about' do
	erb :about
end

# contact page
get '/contact' do
	erb :contact
end




# get students - all
get '/students' do
	@students = Student.all
	erb :students
end
# get student - using id
get "/student/:id" do
 @student = Student.find(params[:id])
 erb :student_info
end
# create student
post '/student' do
	@student = Student.create(name: params[:name], info: params[:info])
	redirect '/students'
end
# update student
put '/student/:id' do
	@student = Student.find(params[:id])
	@student.update(name: params[:name], info: params[:info])
	@student.save
	redirect '/student/'+params[:id]
end
# delete student
delete '/student/:id' do
	@student = Student.find(params[:id])
	@student.destroy
	redirect '/students'
end



# get comments - all
get '/comments' do
	@comments = Comment.all
	erb :comments
end
# get comment - using id
get "/comment/:id" do
 @comment = Comment.find(params[:id])
 erb :comment_content
end
# create comment
post '/comment' do
	@comment = Comment.create(title: params[:title], content: params[:content])
	redirect '/comments'
end


# get video
get '/video' do
	erb :video
end

# signup
get '/signup' do
	erb :signup
end
post '/signup' do
	@user = User.create(name: params[:name], email: params[:email], pwd: params[:pwd])
	session[:user_id] = @user.id
	redirect '/logout'
end

#login
get '/login' do
	@users = User.all
	erb :login
end

post '/login' do
	@user = User.find_by(email: params["email"], pwd: params["pwd"])
	session[:user_id] = @user.id
	redirect '/logout'
end

#logout
get '/logout' do
	@sid = session[:user_id]
	@user = User.find(@sid)
	erb :logout
end
post '/logout' do
	session.clear
	redirect '/login'
end



# #login/logout related
# get '/loginout' do
# 	@users = User.all
# 	erb :loginout
# end
#
# # create user
# post '/loginout' do
# 	@user = User.create(name: params[:name], email: params[:email], pwd: params[:pwd])
# 	session[:id] = @user.id
# 	redirect '/loginout/'+ @user.id
# end
