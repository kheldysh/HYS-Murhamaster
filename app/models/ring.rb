class Ring < ActiveRecord::Base
  has_many :assignments
  belongs_to :tournament
  accepts_nested_attributes_for :assignments, :allow_destroy => true
end
