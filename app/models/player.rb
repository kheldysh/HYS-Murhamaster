class Player < ActiveRecord::Base

  belongs_to :user
  belongs_to :tournament
  belongs_to :team
  belongs_to :referee
  
  has_many :assignments
  has_many :targets, :through => :assignments


  def with_real_name
    "#{self.user.full_name}, #{self.alias}"
  end

  def to_s
    if team != nil
      "%s (%s)" % [ self.alias, self.team.name ]
    else
      self.alias
    end      
  end    

end
