class User < ActiveRecord::Base
  rolify
  scope :deactivated, where("deleted_at IS NOT NULL")
  scope :active, where("deleted_at IS NULL")
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  has_many :logs

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  #
  def attempt_set_password(params)
    update_attributes(:password => params[:password], :password_confirmation => params[:password_confirmation])
  end

  def admin?
    self.has_role? :admin
  end

  def active_for_authentication?
    super && !deleted_at
  end

  def self.find_for_authentication(conditions)
    super(conditions.merge(:deleted_flag => false))
  end
end
