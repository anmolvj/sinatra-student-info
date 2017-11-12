require "./models.rb"
require "sinatra"


# set :database, "sqlite3:assignment3db.sqlite3"
enable :sessions

class Main
	puts "Connected..."
end

configure do
	enable :sessions
	set :username, "anmol"
	set :password, "vijayvargiya"
end


student = Student.new firstname: "fire", lastname: "bom",  address:"my address", student_id: 1284369, birthday_year: 1999, birthday_month: 10, birthday_day: 23
student.save
comment = Comment.new name: "first comment", content: "These are the contents of this first comment"
comment.save

# index page
get '/' do
	@sid = session[:user_id]
	@user = User.get(@sid)
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
 @student = Student.get(params[:id])
 erb :student
end
# create student
post '/student' do
	@student = Student.new
	@student.firstname = params[:firstname]
	@student.lastname = params[:lastname]
	@student.address = params[:address]
	@student.student_id = params[:student_id]
	@student.extrainfo = params[:extrainfo]
	@student.birthday_year = params[:birthday_year].to_s
	@student.birthday_month = params[:birthday_month].to_s
	@student.birthday_day = params[:birthday_day].to_s
	if (Student.count(student_id: @student.student_id) == 0)
		@student.save
		redirect '/students'
	else
		session[:error_message] = "The student with given credentials already exists"
		redirect '/students'
	end
end
# update student
put '/student/:id' do
	@student = Student.get(params[:id])
	@student.update(firstname: params[:firstname], lastname: params[:lastname], address: params[:address], student_id: params[:student_id], extrainfo: params[:extrainfo], birthday_year: params[:birthday_year], birthday_month: params[:birthday_month], birthday_day: params[:birthday_day])
	redirect '/student/'+params[:id]
end
# delete student
delete '/student/:id' do
	@student = Student.get(params[:id])
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
 @comment = Comment.get(params[:id])
 erb :comment
end
# create comment
post '/comment' do
	@comment = Comment.create(name: params[:name], content: params[:content])
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
	@user = User.new
	@user.name = params[:name]
	@user.email = params[:email]
	@user.password = params[:password]
	if (User.count(email: @user.email, password: @user.password) == 0)
		@user.save
		session[:user_id] = @user.id
		session[:error_message] = ""
		redirect '/logout'
	else
		session[:error_message] = "The user with given credentials already exists"
		redirect '/login'
	end
end

#login
get '/login' do
	@error_message = session[:error_message]
	@users = User.all
	erb :login
end

post '/login' do
	@user = User.first(email: params["email"], password: params["password"])
	if @user
		session[:user_id] = @user.id
		redirect '/logout'
	else
		session[:error_message] = "User doesn't exist. Please signup."
		redirect '/login'
	end	
end

#logout
get '/logout' do
	@sid = session[:user_id]
	@user = User.get(@sid)
	erb :logout
end
post '/logout' do
	session.clear
	redirect '/login'
end
