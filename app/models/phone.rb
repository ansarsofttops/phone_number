class Phone < ApplicationRecord
  UPPER_BOUND = 9999999999
  LOWER_BOUND = 1111111111


  validates_format_of :number, :with =>  /\d[0-9]\)*\z/ , :message => "Only positive number are allowed", allow_blank: true
  validates_uniqueness_of :number
  validate :valid_number

  scope :system_genrated_records, -> { order(:number).where(system_genrated: true) }

  before_validation :acquire_next_available_number
  after_save :convert_special_to_system_genrated_number!

  def acquire_next_available_number
    self.number = LOWER_BOUND if number == 0
    if acquire_requested_number? || lower_bound_number?
      self.number = next_system_genrated
      self.system_genrated = true
    else
      self.special_number = true
    end
    self.system_genrated = true if lower_bound_number?
  end

  def acquire_requested_number?
    Phone.where(number: number).any?
  end

  def number=(val)
    super(val.to_s.gsub('-', '').gsub(' ', '').to_i)
  end

  def next_system_genrated
    Phone.system_genrated_records.last&.number&.next || LOWER_BOUND
  end

  def special_number? number
    Phone.find_by(number: number)&.special_number
  end

  def lower_bound_number?
    LOWER_BOUND == number
  end

  def upper_bound_number?
    UPPER_BOUND == number
  end

  def convert_special_to_system_genrated_number!
    if system_genrated && special_number?(number.next)
      special_num = Phone.find_by_sql("select min(l.number) as start from phones as l left outer join phones as r on l.number + 1 = r.number where r.number is null AND l.special_number is true AND l.number >= #{number.next}")
      Phone.where(number: number.next..special_num.first.start).update_all(system_genrated: true)
    end
  end

  def valid_number
    return true if (LOWER_BOUND..UPPER_BOUND).include?(self.number)
    errors.add(:number, "Please enter a valid number(#{LOWER_BOUND} - #{UPPER_BOUND}")
  end
end
