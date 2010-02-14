class Team < ActiveRecord::Base

  has_many :players
  has_many :team_assignments
  has_many :targets, :through => :team_assignments


  belongs_to :tournament

end
