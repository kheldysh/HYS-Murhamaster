class Tournament < ActiveRecord::Base
  has_many :players
  has_many :teams
  has_many :assignments
  has_many :team_assignments
  has_many :referees
  has_many :users, :through => :referees
  
  def app_deadline_fin
    if app_deadline
      return app_deadline.strftime("%d.%m.%Y klo %H.%M")
    end
  end
    
  named_scope :registration_open, :conditions => ["app_deadline > ?", Time.now]
end
