# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include UserAuthentication
  
  def show_image(picture)
    send_data picture.data, :type => picture.content_type, :disposition => 'inline', :filename => picture.name
  end

end
