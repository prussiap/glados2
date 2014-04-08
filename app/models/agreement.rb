class Agreement < ActiveRecord::Base
  ALL_AUTHOR_TYPES = [
    COUNSEL   = "Counsel",
    MANAGEMENT = "Management"
  ]

  attr_accessible :name, :version, :author, :agreement_execution
  has_many :agreement_executions

  validates :name, :presence => { :message => "Please enter a name"}
  validates :version, :presence => { :message => "Please enter a version"}, :numericality => {:only_integer => true}
  validates :author, :presence => { :message => "Please enter an author"}
  validates_inclusion_of :author, :in => ALL_AUTHOR_TYPES, :message => "Not the correct author type"
end

