class ApplicationController < ActionController::Base
  before_filter :set_encoding
  
  def set_encoding
     headers['Content-Type'] ||= 'text/html'
      if headers['Content-Type'].starts_with?('text/') and !headers['Content-Type'].include?('charset=')
        headers['Content-Type'] += '; charset=UTF-8'
      end
  end

  def render_404
    render :file => "#{RAILS_ROOT}/public/404.html", :status => '404 Not Found'
  end
end