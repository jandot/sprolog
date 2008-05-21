class HomeController < ApplicationController

  def index
    if ! session[:user].nil?
      redirect_to :controller => :users, :action => :show, :id => session[:user]
    end
  end
end
