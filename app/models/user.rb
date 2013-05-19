class User < ActiveRecord::Base

  require 'digest/sha1'

  has_many :players
  has_one :calendar
  has_one :picture
  has_many :referees
  has_many :tournaments, :through => :referees

  accepts_nested_attributes_for :calendar
  accepts_nested_attributes_for :picture
  accepts_nested_attributes_for :players

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

    if user && user.password == hash_plaintext_password(password)
      logger.info "correct info"
      return user
    else
      return nil
     end
  end

  def is_referee?
    !self.referees.empty?
  end

  def is_referee_for?(tournament)
    tournament.referees.any? { |referee| referees.include?(referee) }
  end

  def is_current_referee_for?(player)
    @referees.map(&:tournament).select(&:is_running?).each do |tournament|
      return true if tournament.players.include? player
    end
  end

  def self.augment_if_exists(username) # if username exists, appends order number
    augmentation = 1
    new_user = username
    while User.exists?(:username => new_user)
      new_user = username + augmentation.to_s
      augmentation += 1
    end
    return new_user
  end

  def reset_password
    new_pass = SecureRandom.hex(6)
    self.password = User.hash_plaintext_password(new_pass)
    new_pass
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

