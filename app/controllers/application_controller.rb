class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	def render_json(json = {})
	    render :text=> JSON.generate({:status => 0, :msg => "success."}.merge(json))
	end

end
