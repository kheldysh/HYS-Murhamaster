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

  before_validation :default_status
  before_validation :symbolize_status

  def status
    status = read_attribute(:status)
    status.to_sym if status
  end
  def status=(value)
    write_attribute(:status, value)
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

  private

  def symbolize_status
    self.status = self.status.to_sym if self.status
  end

  def default_status
    self.status ||= :waiting_approval
  end

end

