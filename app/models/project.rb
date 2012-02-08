class Project < ActiveRecord::Base

has_many :shares
has_many :users, :through => :shares

has_many :lists

validates :name, 	:presence => true

def author
  User.find_by_id(shares.select(:user_id).where("author == ?",true))
end



end
