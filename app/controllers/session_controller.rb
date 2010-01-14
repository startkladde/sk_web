require 'util'

class SessionController < ApplicationController
	allow_public :login, :logout, :settings

	filter_parameter_logging :current_password, :password, :password_confirmation

	def login
		render and return if !request.post?

		username=params[:username]
		password=params[:password]

		if username && password
			if User.authenticate(username, password)
				session[:username]=username

				flash[:notice]="Angemeldet als #{username}"

				# The page we tried to access is stored as the origin
				redirect_to_origin(default=root_path)
			else
				flash.now[:error]="Die angegebenen Anmeldedaten sind nicht korrekt."
				@username=username
				render
			end
		else
			render
		end
	end

	def logout
		reset_session

		flash[:notice]="Abgemeldet"
		redirect_to root_path
	end

	def settings
		session[:debug]=params[:debug].to_b

		flash[:notice]="Die Diagnosefunktionen wurden #{(session[:debug])?"aktiviert":"deaktiviert"}."

		# It's hard to get the redirect right, especially if we're deactivating
		# the debug functions from the redirect page after activating them - it
		# will redirect :back to activate them.
		#redirect_to :back
		redirect_to root_path
	end
end

