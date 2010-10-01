class Tournament < ActiveRecord::Base
  has_many :players
  has_many :teams
  has_many :assignments
  has_many :team_assignments
  has_many :referees
  has_many :users, :through => :referees
  
  @referee_headroom = 30
  
  def self.referee_headroom
    @referee_headroom
  end 
  
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
    Date.today <= finish_date + self.referee_headroom
  end
    
  named_scope :registration_open, :conditions => ["app_deadline > ?", Time.now]
  named_scope :relevant_for_referee, :conditions => ["finish_date >= ?", Date.today - self.referee_headroom]
end
