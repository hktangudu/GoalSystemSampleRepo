class RegisterController < ApplicationController

	def register
		if logged_in?
			redirect_to :action => 'main', :id => current_user.id
		else
			@user = User.new
		end
		
	end

	def CreateUser
		@user = User.create(reg_params)
		if @user.save
			redirect_to :action => 'signin' 
		else
			render :register
		end
	end

	# def loadondate
	# 	@usergoalsbydate = Goal.where("userid = :userid and Date(created_at) = :date", { userid: params[:id], date: params[:selecteddate] })
	# 	respond_to do |format|
	# 		format.html
	# 		format.json {render :json => @usergoalsbydate}
	# 	end
	# end

	def main
		@user = User.find_by(id: params[:id])
		@usergoals = Goal.where("userid = :userid and Date(created_at) = :date", { userid: params[:id], date: Date.today })
		
	end

	def getallpendinggoals

		@usersallpendinggoals = Goal.where(:userid => current_user.id)

	#	respond_to do |format|
	#    	format.html
	#    	format.json {render :json => @usersallpendinggoals}
	#	end

	#	redirect_to action: 'main', :id => current_user.id

  	end

	
	

	def signin
		@user = User.new
		@usergoals = Goal.new
	end

	def passwordchange
		cpuser = User.find_by(id: current_user.id)
				if cpuser.update_attribute(:password, params[:user][:password])
			flash[:changepassword] = 'Your Password has been changed successfully'
			redirect_to action:'main', :id => current_user.id
		else
			redirect_to action:'main', :id => current_user.id
		end
	end

	def authenticateuser
		@user = User.find_by(emailid: params[:user][:emailid].downcase)
		if @user && @user.authenticate(params[:user][:password])
	      	log_in @user
	      	
		    redirect_to action: 'main', :id => current_user.id
	    else
	      flash[:notice] = 'Unknown user. Please check your username and password.'
	      redirect_to :action =>'signin'
	    end
	end

	def updategoal
		# @goal = Goal.new()
		
		# @goal = Goal.create({:label => params[:label],:goal => params[:goal],:status => params[:status],:remarks => params[:remarks],:userid => current_user.id});
		usergoal = Goal.find_by(id: params[:goalid])
		if usergoal.update_attributes(:label => params[:label],:goal => params[:goal],:status => params[:status],:remarks => params[:remarks],:userid => current_user.id)
			redirect_to action: 'main', :id => current_user.id
		else
			redirect_to action: 'main', :id => current_user.id
		end
	end

	def addusergoal
		@goal = Goal.new()
		
		@goal = Goal.create({:label => '',:goal => '',:status => 'New',:remarks => '',:userid => current_user.id});
		if @goal.save
			redirect_to action: 'main', :id => current_user.id
		else
			redirect_to action: 'main', :id => current_user.id
		end
	end

	def logout
		log_out
		flash[:logout] = 'You have been logged out successfully'
		redirect_to root_url
	end

	def reg_params
		params.require(:user).permit(:name, :emailid, :password, :password_confirmation)
	end
  

end
