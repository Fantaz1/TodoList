class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :shares, :dependent => :destroy
  has_many :projects, :through => :shares, :dependent => :destroy
  
  has_and_belongs_to_many :tasks

	has_many :shared_projects, :source => "project", :through => :shares, :conditions => ['author = ?', false]

	has_many :my_projects, :source => "project", :through => :shares, :conditions => ['author = ?', true]
end
