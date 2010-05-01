require 'date'
require 'fileutils'

module TimeConverter
  def to_minutes colon_separated_string
    tmp = colon_separated_string.split(":")
    tmp[0].to_i * 60 + tmp[1].to_i + tmp[2].to_i / 60.0
  end
end

class Limit
  def initialize(upper, lower)
    @upper, @lower = upper, lower
  end
  def to_s
    "[#{@upper}, #{@lower}]"
  end
end

class Exersice
  include TimeConverter

  attr_accessor :max_hr, :length, :resting_hr, :vo2_max, :weight, :hr_data

  def date(day, time)
    @date = DateTime.parse "#{day[0..3]}-#{day[4..5]}-#{day[6..7]} #{time}"
  end

  def limits(upper, lower)
    @limits = Limit.new(upper, lower)
  end

  def average_hr
    @hr_data.inject {|x,y| x.to_i + y.to_i} / @hr_data.size
  end

  def calories
    litersPerMin = (average_hr.to_i * 1.0 / @max_hr.to_i ) * @vo2_max.to_i * @weight.to_i / 1000.0
    minutes = to_minutes @length
    (litersPerMin * 3.8 * minutes).ceil 
  end

  def summary
    "Exersice Summary: \n" + 
      "Date: #{@date}\n" + 
    "Lenght: #{@length}\n" + 
    "Limits: #{@limits}\n" +
    "Max Heart Rate: #{@max_hr}\n" + 
    "Resting Heart Rate: #{@resting_hr}\n" +
    "VO2 Max: #{@vo2_max}\n" +
    "Weight: #{@weight}\n" + 
    "Average Heart Rate: #{average_hr}\n" + 
    "Calories (kcal): #{calories}\n" + 
    "HR Data: \n[#{@hr_data.join(",")}]"
  end
end

class ExersiceBuilder
  def self.build(file)
    exersice = Exersice.new
    exersice.date(file[/Date=(.+)$/i, 1], file[/StartTime=(.+)$/i, 1])
    exersice.length = file[/Length=(.+)$/i, 1]
    exersice.limits(file[/Upper1=(.+)$/i, 1], file[/Lower1=(.+)$/i, 1])
    exersice.max_hr = file[/MaxHR=([\d]+)$/i, 1]
    exersice.resting_hr = file[/RestHR=([\d]+)$/i, 1]
    exersice.vo2_max = file[/VO2max=([\d]+)$/i, 1]
    exersice.weight = file[/Weight=([\d]+)$/i, 1]


    exersice.hr_data = extract_hr_data(file)

    exersice
  end

  def self.extract_hr_data(file)
    smode = file[/SMode=(.+)$/i,1]
    if smode == "000000001"
      file[file.index(/HRData\]/) + 8..file.size].split("\n")
    elsif smode == "001000100"
      file[file.index(/HRData\]/) + 8..file.size].split("\n").collect do |line|
	line.split(" ")[0]
      end
    else
      throw "Unsupported SMode type"
    end
  end

end

Process.exit unless $0 == __FILE__

if ARGV.length < 1
  puts "Usage: ruby parser [path to hrm file]"
  Process.exit
end
file = ARGV[0]

puts "HRM File: #{file}"
exersice = ExersiceBuilder.build(File.open(file, "r").read)
puts exersice.summary

