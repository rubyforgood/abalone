class DateParser
  # Returns the parsed date if it's in the mm/dd/yy format, and nil otherwise
  def self.parse(date)
    DateTime.strptime(date, "%m/%d/%y") if date_regex.match? date
  rescue ArgumentError
    nil
  end

  # regex to checking mm/dd/yy format for strptime above
  def self.date_regex
    Regexp.new('\d{1,2}\/\d{1,2}\/\d{2}\z').freeze
  end
end
