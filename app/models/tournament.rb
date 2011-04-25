class Tournament < ActiveRecord::Base
  has_many :players
  has_many :teams
  has_many :assignments
  has_many :rings
  has_many :team_assignments
  has_many :referees
  has_many :users, :through => :referees
  has_many :events
  
  def app_deadline_formatted
    if app_deadline
      return app_deadline.strftime("%d.%m.%Y, %H.%M")
    end
  end
  
  def is_running?
    start_date <= Date.today and Date.today <= finish_date
  end
  
  # We give 30 days of headroom for referees to manage the aftergame
  def is_relevant_for_referee?
    Date.today <= finish_date + 30
  end
   
  def descending_events
    events
  end
   
  named_scope :registration_open, :conditions => ["app_deadline > ?", Time.now]
end
