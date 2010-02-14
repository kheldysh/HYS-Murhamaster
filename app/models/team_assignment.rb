class TeamAssignment < ActiveRecord::Base

  belongs_to :team
  belongs_to :tournament
  
  belongs_to :target, :class_name => "Team", :foreign_key => "target_id"

end
