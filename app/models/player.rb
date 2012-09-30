class Player < ActiveRecord::Base

  belongs_to :user
  belongs_to :tournament
  belongs_to :team
  belongs_to :referee

  has_one :warrant
  has_many :assignments
  has_many :targets, :through => :assignments

  validates_inclusion_of :status, :in => [:waiting_approval, :active, :detective, :dead]

  scope :waiting_players, :conditions => ["status = ?", "waiting_approval"]

  scope :active_players, :conditions => ["status = ?", "active"]
  scope :dead_players, :conditions => ["status = ?", "dead"]
  scope :detectives, :conditions => ["status = ?", "detective"]

  scope :participating, :conditions => ["status != ?", "waiting_approval"]

  def status
    read_attribute(:status).to_sym
  end
  def status= (value)
    write_attribute(:status, value.to_s)
  end

  def waiting_approval?
    self.status == :waiting_approval
  end

  def detective?
    self.status == :detective
  end

  def active?
    self.status == :active
  end

  def dead?
    self.status == :dead
  end


  def with_real_name
    "#{self.user.full_name}, #{self.alias}"
  end

  def real_name
    self.user.full_name
  end

  def to_s
    if team != nil
      "%s (%s)" % [ self.alias, self.team.name ]
    else
      self.alias
    end
  end

end

