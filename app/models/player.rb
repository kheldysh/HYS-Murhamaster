class Player < ActiveRecord::Base

  belongs_to :user
  belongs_to :tournament
  belongs_to :team
  belongs_to :referee
  
  has_many :assignments
  has_many :targets, :through => :assignments

  validates_inclusion_of :status, :in => [:active, :detective, :dead]
 
  named_scope :active_players, :conditions => ["status > ?", :active]
  named_scope :dead_players, :conditions => ["status > ?", :dead]
  named_scope :detectives, :conditions => ["status > ?", :detective]
   
  def status
    read_attribute(:status).to_sym
  end
  def status= (value)
    write_attribute(:status, value.to_s)
  end


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
