require 'date'
require 'fileutils'

class Exersice
  attr_accessor :max_hr, :length, :resting_hr, :vo2_max, :weight, :hr_data

  def date(day, time)
    @date = DateTime.parse "#{day[0..3]}-#{day[4..5]}-#{day[6..7]} #{time}"
  end

  def limits(upper, lower)
    @limits = [upper,lower]
  end

  def average_hr
    @hr_data.inject {|x,y| x.to_i + y.to_i} / @hr_data.size
  end

  def summary
    "Date: #{@date}\n" + 
    "Lenght: #{@length}\n" + 
    "Limits: [#{@limits[0]}, #{@limits[1]}]\n" +
    "Max Heart Rate: #{@max_hr}\n" + 
    "Resting Heart Rate: #{@resting_hr}\n" +
    "VO2 Max: #{@vo2_max}\n" +
    "Weight: #{@weight}\n" + 
    "Average Heart Rate #{average_hr}\n" + 
    "HR Data: \n[#{@hr_data.join(",")}]"
  end
end

class ExersiceBuilder
  def self.build(file)
     throw "Error: Unsupported SMode (Not yet implemented)" unless file[/SMode=000000001/,0]

    exersice = Exersice.new
    exersice.date(file[/Date=(.+)$/i, 1], file[/StartTime=(.+)$/i, 1])
    exersice.length = file[/Length=(.+)$/i, 1]
    exersice.limits(file[/Upper1=(.+)$/i, 1], file[/Lower1=(.+)$/i, 1])
    exersice.max_hr = file[/MaxHR=([\d]+)$/i, 1]
    exersice.resting_hr = file[/RestHR=([\d]+)$/i, 1]
    exersice.vo2_max = file[/VO2max=([\d]+)$/i, 1]
    exersice.weight = file[/Weight=([\d]+)$/i, 1]

    exersice.hr_data = file[file.index(/HRData\]/) + 8..file.size].split("\n")
    exersice
  end
end

exersice = ExersiceBuilder.build(File.open("test.hrm", "r").read)
puts exersice.summary
