class Tournament < ActiveRecord::Base
  has_many :players
  has_many :teams
  
  def app_deadline_fin
    if app_deadline
      return app_deadline.strftime("%d.%m.%Y klo %H.%M")
    end
  end
    
end
