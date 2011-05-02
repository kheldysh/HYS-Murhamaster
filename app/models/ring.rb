class Ring < ActiveRecord::Base
  has_many :assignments, :dependent => :destroy
  belongs_to :tournament
  accepts_nested_attributes_for :assignments, :allow_destroy => true
  
  # workaround for :dependent => :destroy not working
  before_destroy :wipe_assignments
  
  def wipe_assignments
    assignments.each do |ass|
      ass.destroy
    end
  end
  
end
