class EmailAddress < ActiveRecord::Base
  acts_as_illyan_shared_model
  belongs_to :person
  validates_uniqueness_of :address
  
  def primary=(value)
    if value and not person.nil?
      person.email_addresses.each do |addr|
        if addr != self
          addr.primary = false
          addr.save
        end
      end
    end
    write_attribute(:primary, value)
  end
end
