# encoding: utf-8

class Warrant < ActiveRecord::Base
  has_many :assignments, :dependent => :destroy
  belongs_to :tournament
  
  belongs_to :target, :class_name => "Player", :foreign_key => "target_id"
  
  accepts_nested_attributes_for :assignments, :allow_destroy => true

  # workaround for :dependent => :destroy not working
  before_destroy :wipe_assignments
  
  validate :single_target_on_all_assignments?
  validate :target_is_not_blank?

  def wipe_assignments
    assignments.each do |ass|
      ass.destroy
    end
  end
  
  def single_target_on_all_assignments?
    assignments.each do |ass|
      if ass.target != assignments.first.target
        errors.add(:ass, I18n.t('warrant.too_many_targets'))
      end
    end
  end
  
  def target_is_not_blank? 
    assignments.each do |ass|
      if ass.target.blank?
        errors.add(:ass, I18n.t('warrant.target_missing'))
      end
    end
  end
  
end
