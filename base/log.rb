require 'csv'

module Logger

  def write_to_file(filename, data)
    CSV.open(filename, 'w') do |csv|
      data.each do |row|
        csv << row
      end
    end  
  end
  
end