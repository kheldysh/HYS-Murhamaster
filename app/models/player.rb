class Player < ActiveRecord::Base

  belongs_to :user
  belongs_to :tournament
  belongs_to :team
  
  has_many :targets, :through => :assignments

  def to_s
    if team != nil
      "%s (%s)" % [ self.alias, team ]
    else
      self.alias
    end      
  end
      

end
