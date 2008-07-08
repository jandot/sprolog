# This controller handles the login/logout function of the site.  
class SessionController < ApplicationController


  # render new.rhtml
  def new
  end
  
  def create
    open_id_authentication(params[:openid_url])
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(home_path)
  end

  protected
    def open_id_authentication(openid_url)
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
      redirect_back_or_default(home_path)
      flash[:notice] = "Logged in successfully"
    end

    def failed_login(message)
      flash[:warning] = "Login unsuccessful. " + message
      redirect_to('login_path')
    end
end
