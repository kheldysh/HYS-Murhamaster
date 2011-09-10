class Tournament < ActiveRecord::Base
  has_many :players
  has_many :teams
  has_many :assignments
  has_many :rings
  has_many :warrants
  has_many :team_assignments
  has_many :referees
  has_many :users, :through => :referees
  has_many :events

  before_create :update_stats

  def app_deadline_formatted
    if app_deadline
      return app_deadline.strftime("%d.%m.%Y, %H.%M")
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

  # We give 30 days of headroom for referees to manage the aftergame
  def is_relevant_for_referee?
    Date.today <= finish_date + 30
  end

  named_scope :registration_open, :conditions => ["app_deadline > ?", Time.now]


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
    tournament.save!
  end

end

