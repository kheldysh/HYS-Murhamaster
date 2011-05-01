class Warrant < ActiveRecord::Base
  has_many :assignments, :dependent => :destroy
  belongs_to :tournament
  
  belongs_to :target, :class_name => "Player", :foreign_key => "target_id"
  
  accepts_nested_attributes_for :assignments, :allow_destroy => true
  
  validate :single_target_on_all_assignments?
  validate :target_is_not_blank?
  
  def single_target_on_all_assignments?
    assignments.each do |ass|
      if ass.target != assignments.first.target
        errors.add(:ass, "Etsintäkuulutuksessa saa olla vain yksi kohde.")
      end
    end
  end
  
  def target_is_not_blank? 
    assignments.each do |ass|
      if ass.target.blank?
        errors.add(:ass, "Etsintäkuulutuksen toimeksiannosta puuttuu kohde!")
      end
    end
  end
  
end
