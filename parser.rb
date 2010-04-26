require 'fileutils'

class Exersice
  def date(day, time)
    @date = DateTime.parse "#{day[0..3]}-#{day[4..5]}-#{day[6..7]} #{time}"
  end
  
  def length=len
    @length = len
  end

  def limits(upper, lower)
    @limits = [upper,lower]
  end

  def max_hr=hr
    @max_hr = hr
  end

  def summary
    "Date: #{@date}\n" + 
    "Lenght: #{@length}\n" + 
    "Limits: [#{@limits[0]}, #{@limits[1]}]\n" +
    "Max Heart Rate: #{@max_hr}"
  end
end

exersice = Exersice.new

file = File.open("test.hrm", "r").read
exersice.length = file[/Length=(.+)$/i, 1]
exersice.limits(file[/Upper1=(.+)$/i, 1], file[/Lower1=(.+)$/i, 1])
exersice.max_hr = file[/MaxHR=([\d]+)$/i, 1]
puts "Resting HR: " + file[/RestHR=([\d]+)$/i, 1]
puts "VO2max: " + file[/VO2max=([\d]+)$/i, 1]
puts "Weight: " + file[/Weight=([\d]+)$/i, 1]


exersice.date(file[/Date=(.+)$/i, 1], file[/StartTime=(.+)$/i, 1])
puts exersice.summary
