# This controller handles the login/logout function of the site.  
class SessionController < ApplicationController


  # render new.rhtml
  def new
  end

#  def show
#    redirect_to :controller => :users, :action => :show, :id => sess
#  end
  
  def create
    if using_open_id?
      open_id_authentication(params[:openid_url])
    elsif params[:login]
      password_authentication(params[:login], params[:password])
    end
#    self.current_user = User.authenticate(params[:login], params[:password])
#    if logged_in?
#      session[:user] = User.find(self.current_user)
#      
#      redirect_to :controller => :users, :action => :show, :id => self.current_user
#      flash[:notice] = "Logged in successfully"
#    else
#      render :action => 'new'
#    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(home_path)
  end

  protected
  
    def password_authentication(login, password)
      if self.current_user == User.authenticate(params[:login], params[:password])
        successful_login
      else
        failed_login("Invalid login or password")
      end
    end
 
    def open_id_authentication(openid_url)
#      authenticate_with_open_id do |result, identity_url|
#        if result.successful?
#          if self.current_user = User.find_or_create_by_identity_url(identity_url)
#            successful_login
#          else
#            failed_login "Sorry, no user by that identity URL exists (#{identity_url})"
#          end
#        else
#          failed_login result.message
#        end
#      end
       authenticate_with_open_id(openid_url, :required => [:nickname, :email]) do |result, identity_url, registration|
        if result.successful?
          @user = User.find_or_initialize_by_identity_url(identity_url)
          if @user.new_record?
            @user.login = registration['nickname']
            @user.email = registration['email']
            @user.save(false)
          end
          self.current_user = @user
          successful_login
        else
          failed_login result.message
        end
       end

    end
    
  private
  
    def successful_login
            logger.debug "===================="

      redirect_back_or_default(home_path)
      flash[:notice] = "Logged in successfully"
    end

    def failed_login(message)
      flash[:warning] = "Login unsuccessful. " + message
      redirect_to('/login')
      logger.debug "============ " + message + " ============="

    end
end
