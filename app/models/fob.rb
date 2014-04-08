class Fob < ActiveRecord::Base
  attr_accessible :key, :person, :person_id
  belongs_to :person
  validates :key, :presence => true, :uniqueness => true
end


