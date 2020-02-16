class DateParser
  def self.parse(date)
    if date_regex.match? date
      DateTime.strptime(date, "%m/%d/%y")
    else
      nil
    end
  rescue ArgumentError
    nil
  end

  private

  # regex to checking mm/dd/yy format for strptime above
  def self.date_regex
    Regexp.new('\d{1,2}\/\d{1,2}\/\d{2}\z').freeze
  end
end
