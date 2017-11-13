require "./models.rb"
require "sinatra"


#enabling sessions to use for purpose of user authentcation
enable :sessions

class Main
	puts "Connected..."
end

configure do
	enable :sessions
	set :username, "anmol"
	set :password, "vijayvargiya"
end



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
	@students_error_message = session[:students_error_message]
	session[:students_error_message] = ""
	erb :students
end
# get student - using id
get "/student/:id" do
 @student = Student.get(params[:id])
 @student_error_message = session[:student_error_message]
 session[:student_error_message] = ""
 erb :student
end

# create student
post '/student' do
	session[:students_error_message] = ""
	if (params[:firstname].strip.empty? )
		session[:students_error_message] = "First Name field is Mandetory"
		redirect '/students'
	end
	if (params[:lastname].strip.empty?)
		session[:students_error_message] = "Last Name field is Mandetory"
		redirect '/students'
	end
	if (params[:student_id].strip.empty?)
		session[:students_error_message] = "Student ID field is Mandetory"
		redirect '/students'
	end
	if (params[:birthday_year].to_s.strip.empty?)
		session[:students_error_message] = "Birthday Year field is Mandetory"
		redirect '/students'
	end
	if (params[:birthday_month].to_s.strip.empty?)
		session[:students_error_message] = "Birthday Month field is Mandetory"
		redirect '/students'
	end
	if (params[:birthday_day].to_s.strip.empty?)
		session[:students_error_message] = "Birthday Day field is Mandetory"
		redirect '/students'
	end

	if (session[:students_error_message] == "")
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
					session[:students_error_message] = "The student with given credentials already exists"
					redirect '/students'
				end
		else
			session[:students_error_message] = ""
			redirect '/students'
	end
end


# update student
put '/student/:id' do
	@student = Student.get(params[:id])
	session[:student_error_message] = ""
	if (params[:firstname].strip.empty? )
		session[:student_error_message] = "First Name field is Mandetory"
		redirect '/student/'+params[:id]
	end
	if (params[:lastname].strip.empty?)
		session[:student_error_message] = "Last Name field is Mandetory"
		redirect '/student/'+params[:id]
	end
	if (params[:student_id].strip.empty?)
		session[:student_error_message] = "Student ID field is Mandetory"
		redirect '/student/'+params[:id]
	end
	if (params[:birthday_year].to_s.strip.empty?)
		session[:student_error_message] = "Birthday Year field is Mandetory"
		redirect '/student/'+params[:id]
	end
	if (params[:birthday_month].to_s.strip.empty?)
		session[:student_error_message] = "Birthday Month field is Mandetory"
		redirect '/student/'+params[:id]
	end
	if (params[:birthday_day].to_s.strip.empty?)
		session[:student_error_message] = "Birthday Day field is Mandetory"
		redirect '/student/'+params[:id]
	end

	if (session[:student_error_message] == "")
		@student.update(firstname: params[:firstname], lastname: params[:lastname], address: params[:address], student_id: params[:student_id], extrainfo: params[:extrainfo], birthday_year: params[:birthday_year], birthday_month: params[:birthday_month], birthday_day: params[:birthday_day])
		redirect '/student/'+params[:id]
	end
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
	@comments_error_message = session[:comments_error_message]
	session[:comments_error_message] = ""
	erb :comments
end
# get comment - using id
get "/comment/:id" do
 @comment = Comment.get(params[:id])
 erb :comment
end
# create comment
post '/comment' do
	if (params[:name].strip.empty? )
		session[:comments_error_message] = "Comment without a name cannot be submitted."
	elsif (params[:content].strip.empty?)
		session[:comments_error_message] = "Comment without content cannot be submitted."
	else
		@comment = Comment.create(name: params[:name], content: params[:content])
		session[:comments_error_message] = ""
	end
	redirect '/comments'
end


# get video
get '/video' do
	erb :video
end

# get signup form
get '/signup' do
	@signup_error_message = session[:signup_error_message]
	session[:signup_error_message] = ""
	erb :signup
end

# validate signup form
post '/signup' do
	session[:signup_error_message] = ""
	if (params[:name].strip.empty?)
		session[:signup_error_message] = "Name field cannot be blank"
		redirect '/signup'
	end
	if (params[:email].strip.empty?)
		session[:signup_error_message] = "Email field cannot be black"
		redirect '/signup'
	end
	if (params[:password].strip.empty?)
		session[:signup_error_message] = "Please enter a password"
		redirect '/signup'
	end

	# email validation using regex expression
	if (params[:email] =~ /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/)
  	@email_is_valid = true
	else
	  @email_is_valid = false
	end

	if ( !@email_is_valid )
		session[:signup_error_message] = "The email entered is invalid"
		redirect '/signup'
	end

	if (session[:signup_error_message] == "")
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
	redirect '/login'
end

#login
get '/login' do
	@login_error_message = session[:login_error_message]
	session[:login_error_message] = ""
	@users = User.all
	erb :login
end

#validate login form
post '/login' do
	if(params["email"].strip.empty?)
		session[:login_error_message] = "Please enter an email to login."
		redirect '/login'
	end
	if(params["password"].strip.empty?)
		session[:login_error_message] = "Please enter a password to login."
		redirect '/login'
	end
	@user = User.first(email: params["email"], password: params["password"])
	if @user
		session[:user_id] = @user.id
		session[:login_error_message] = ""
		redirect '/logout'
	else
		session[:login_error_message] = "Email and/or password is incorrect or User doesn't exist."
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
