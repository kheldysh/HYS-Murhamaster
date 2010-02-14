class Assignment < ActiveRecord::Base
  belongs_to :player
  
  belongs_to :target, :class_name => "Player", :foreign_key => "target_id"
  
  
end
