class Phone < ApplicationRecord

  PHONE_RANGE_START = 1111111111
  PHONE_RANGE_END = 9999999999

  validates_inclusion_of :phone, :in => PHONE_RANGE_START..PHONE_RANGE_END
  before_create :validate_and_assign_phone_number


  def self.get_all_numbers
    self.pluck(:phone)
  end

  def get_next_available_number
    return PHONE_RANGE_START if Phone.count == 0

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
    if !self.valid? || Phone.get_all_numbers.include?(phone)
      number = self.get_next_available_number
      if number > PHONE_RANGE_END || number < PHONE_RANGE_START
        errors.add(:phone, 'No new number availabe')
      else
        self.phone = number
      end
    else
      errors.add(:phone, 'No new number availabe')
    end
  end

  

end
