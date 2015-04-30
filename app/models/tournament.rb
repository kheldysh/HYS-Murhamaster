class Tournament < ActiveRecord::Base
  has_many :players, :dependent => :delete_all
  has_many :teams
  has_many :assignments
  has_many :rings
  has_many :warrants
  has_many :team_assignments
  has_many :referees
  has_many :users, :through => :referees
  has_many :events

  # before_create update_stats

  scope :registration_open, :conditions => ["app_deadline > ?", Time.now]
  scope :not_finished, :conditions => ["finish_date >= ?", Date.today]
  scope :relevant, :conditions => ["finish_date >= ?", Date.today - 30]

  # We give 14 days of headroom for referees to manage the aftergame
  POSTGAME_VISIBILITY_DAYS = 14

  def app_deadline_formatted
    if app_deadline
      app_deadline.strftime("%d.%m.%Y, %H.%M")
    end
  end

  def is_running?
    start_date <= Date.today and Date.today <= finish_date
  end

  def is_over?
    finish_date < Date.today
  end

  def has_waiting_players?
    players.waiting_players.length > 0
  end

  def is_relevant_for_referee?
    Date.today <= finish_date + POSTGAME_VISIBILITY_DAYS
  end

  def self.update_stats(tournament)

    tournament.murdered = 0
    tournament.killed = 0
    tournament.arrested = 0
    tournament.collaterals = 0
    tournament.witnesses = 0
    tournament.eyewitnesses = 0

    tournament.events.each do |event|
      tournament.murdered += event.murders
      tournament.killed += event.kills
      tournament.arrested += event.arrests
      tournament.collaterals += event.collaterals
      tournament.witnesses += event.witnesses
      tournament.eyewitnesses += event.eyewitnesses
    end
    tournament.save
  end

end

