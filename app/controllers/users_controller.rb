class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		new_user = User.new(user_params)
		session[:user_id] = new_user.id
		if new_user.save
			redirect_to user_path(new_user)
		else
			flash[:alert] = error_message(new_user.errors)
			redirect_to register_path
		end
	end

	def show
		@user = User.find(session[:user_id])
    @my_parties = @user.my_parties
		@party_invites = @user.party_invites
	end

	def login_form

	end

	def login_user
		user = User.find_by(email: params[:email])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			flash[:success] = "Welcome, #{user.name}!"
			redirect_to user_path(user)
		else
			invalid_credentials
		end
	end

	def logout_user
		session.delete(:user_id)
		redirect_to root_path
	end

	private
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

	def invalid_credentials
		flash.now[:alert] = "Email or password is invalid"
		render :login_form, status: 400
	end

	def user_role
		if user.admin?
			redirect_to admin_dashboard_path
		elsif user.manager?
			redirect_to root_path
		else
			redirect_to root_path
		end
	end
end