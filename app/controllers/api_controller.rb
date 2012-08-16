class ApiController < ApplicationController
  def status
    render :json => { :data => render_to_string(:action => '_apistatus', :layout => false) }
  end
  def time
    render :json => { :data => render_to_string(:action => '_time', :layout => false) }
  end
end
