class Referee < ActiveRecord::Base

  belongs_to :tournament
  belongs_to :user
  
  has_many :players
  
  def info
    "%s %s" % [self.user.first_name, self.user.last_name]
  end
  
end
