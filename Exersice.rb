require 'time'

module TimeConverter
  def to_minutes colon_separated_string
    to_seconds(colon_separated_string) / 60
  end
  def to_seconds colon_separated_string
    tmp = colon_separated_string.split(":")
    tmp[0].to_i * 60 * 60 + tmp[1].to_i * 60 + tmp[2][0..1].to_i
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
    @date = Time.parse "#{day[0..3]}-#{day[4..5]}-#{day[6..7]} #{time}"
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

  def get_hr_at(time_stamp)
    at = Time.parse(time_stamp)  
    return @hr_data[0] if at < @date
    return @hr_data[-1] if at > (@date + to_seconds(@length))
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
  def self.build(hrm_data)
    exersice = Exersice.new
    exersice.date(hrm_data[/Date=(.+)$/i, 1], hrm_data[/StartTime=(.+)$/i, 1])
    exersice.length = hrm_data[/Length=(.+)$/i, 1]
    exersice.limits(hrm_data[/Upper1=(.+)$/i, 1], hrm_data[/Lower1=(.+)$/i, 1])
    exersice.max_hr = hrm_data[/MaxHR=([\d]+)$/i, 1]
    exersice.resting_hr = hrm_data[/RestHR=([\d]+)$/i, 1]
    exersice.vo2_max = hrm_data[/VO2max=([\d]+)$/i, 1]
    exersice.weight = hrm_data[/Weight=([\d]+)$/i, 1]
    exersice.hr_data = extract_hr_data(hrm_data)
    exersice
  end

  def self.extract_hr_data(hrm_data)
    smode = hrm_data[/SMode=(.+)$/i,1]
    if smode == "000000001"
      hrm_data[hrm_data.index(/HRData\]/) + 8..hrm_data.size].split("\n")
    elsif smode == "001000100"
      hrm_data[hrm_data.index(/HRData\]/) + 8..hrm_data.size].split("\n").collect do |line|
	line.split(" ")[0]
      end
    else
      throw "Unsupported SMode type"
    end
  end
end

