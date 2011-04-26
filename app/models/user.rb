class User < ActiveRecord::Base

  require 'digest/sha1'

  has_many :players
  has_one :calendar
  has_one :picture
  has_many :referees
  has_many :tournaments, :through => :referees
  
  validates_presence_of :username, :password
  validates_uniqueness_of :username

  validates_length_of :username, :in => 3..15
  
  # validates_length_of :password, :in => 5..30, :allow_blank => true, :on => :update
  # validates_length_of :password, :in => 5..30, :on => :create
  validates_confirmation_of :password

  # attr_accessor :password, :password_confirmation
 
  before_create :hash_password

  def full_name
    "%s %s" % [ self.first_name, self.last_name ]
  end

  def self.authenticate(username, password)
    user = User.find_by_username(username)
    
    logger.info "found user %s" % user
    logger.info "%s == %s" % [hash_plaintext_password(password), user.password]
    if user && user.password == hash_plaintext_password(password)
      logger.info "correct info"
      return user
    else
      return nil
     end
  end
  
  def is_referee?
    return !self.referees.empty?
  end
    
  def is_referee_for?(tournament)
    tournament.referees.each do |referee|
      if current_user.referees.include? referee
        return true
      end
    end
  end

    
  def is_current_referee_for?(player)
    
  end
  
  private
  
  def hash_password
    return if self.password.blank?
    self.password = User.hash_plaintext_password(self.password)
  end
  
  def self.hash_plaintext_password(password)
    Digest::SHA1.hexdigest(password)
  end
 
 
end
