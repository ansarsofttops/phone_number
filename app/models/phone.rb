class Phone < ApplicationRecord

  PHONE_RANGE_START = 1111111111
  PHONE_RANGE_END = 9999999999

  validates_inclusion_of :phone, :in => PHONE_RANGE_START..PHONE_RANGE_END
  validate :validate_and_assign_phone_number


  def self.get_all_numbers
    self.pluck(:phone)
  end

  def get_next_available_number
    return PHONE_RANGE_START if Phone.count == 0 || Phone.where(phone: PHONE_RANGE_START).blank?

    number = Phone.order('phone ASC').first.phone + 1
    while number < PHONE_RANGE_END
      if Phone.where(phone: number).present?
        number = number + 1
      else
        break
      end
    end
    return number
  end 

  private

  def validate_and_assign_phone_number

    return true if Phone.where(phone: self.phone).blank?

    if self.phone.to_i > PHONE_RANGE_END || self.phone.to_i < PHONE_RANGE_START || Phone.get_all_numbers.include?(phone)
      self.phone = self.get_next_available_number
    end

    if self.phone.to_i > PHONE_RANGE_END || self.phone.to_i < PHONE_RANGE_START
      errors.add(:phone, 'No new number availabe')
    end
  end

  

end
