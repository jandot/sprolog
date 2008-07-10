# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all # include all helpers, all the time
  helper_method :owner?
  
  def render_to_pdf(options = nil)
    data = render_to_string(options)
    pdf = PDF::HTMLDoc.new
    pdf.set_option :bodycolor, :white
    pdf.set_option :toc, false
    pdf.set_option :portrait, true
    pdf.set_option :links, false
    pdf.set_option :webpage, true
    pdf.set_option :left, '2cm'
    pdf.set_option :right, '2cm'
    pdf.set_option :footer, "..."
    pdf << data
    pdf.generate
  end

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '20d811d10435b3e130b8ddc134583b90'
  
  protected
  
  def ownership_required
    unless owner?
      flash[:error] = "Unauthorized access: ownership required"
      redirect_to home_path
      false
    end
  end
  
  def owner?
#    object = instance_variable_get("@#{self.controller_class_name.chomp("Controller").singularize.underscore}")
#    STDERR.puts object.to_yaml
#    current_user.id == object.user.id
    class_name = self.controller_class_name.chomp("Controller").singularize
    klass = Kernel.const_get(class_name)
    object = klass.find(session[class_name.underscore.intern])
    
    STDERR.puts "DEBUG: current_user = " + current_user.name + " (" + current_user.id.to_s + ")"
    STDERR.puts "DEBUG: object_user = " + object.user.name
    
    current_user.id == object.user.id
  end
  
end
