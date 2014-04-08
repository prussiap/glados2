class PossessionContract < ActiveRecord::Base
  ALL_CONTRACT_TYPES = [
    LEASE    = 'a lease',
    BORROW   = 'borrow',
    DONATION = 'a donation',
    SALE     = 'a sale'
  ]

  attr_accessible :contract_type, :start_date, :payment, :person, :equipment, :equipment_id, :payment_cents, :expires, :person_id, :equipment_id
  belongs_to :person
  belongs_to :equipment

  validates :contract_type, :presence => { :message => "The type of contract needs to be present"}
  validates :person,:presence => { :message => "A person needs to be associated"}
  validates :equipment_id, :presence => { :message => "Equipment needs to be associated"}, :uniqueness => { :message => "This equipment is already associated, Please choose another"}
  validates_inclusion_of :contract_type, :in => ALL_CONTRACT_TYPES, :message => "That is not an acceptable contract type"
  validates_numericality_of :payment_cents, :only_integer => true, :allow_blank => true
  validates :payment_cents, :presence => true,
    :numericality => {:only_integer => true, :greater_than => 0} , :if => :contract_type_is_lease?
  validates_presence_of :expires, :if => :contract_type_is_lease?
  validates_presence_of :start_date, :if => :contract_type_is_lease?

  def payment=(value)
    if value.to_i == 0
      self.payment_cents = 0
    else
      self.payment_cents = (value.to_f * 100).to_i
    end
  end

  def payment
   if self.payment_cents.nil?
      self.payment_cents
    else
      self.payment_cents.to_f / 100.0
    end
  end

  private
  def contract_type_is_lease?
    contract_type == "a lease"
  end

end
