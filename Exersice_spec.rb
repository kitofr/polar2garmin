require 'rubygems'
require 'spec'
require 'exersice'

describe "get hr data" do
  before(:each) do
    @exersice = Exersice.new
    @exersice.date("20100101", "12:00:00.0")
  end

  it "should give first hr point when request is before training has started" do
    @exersice.hr_data = [110]
    @exersice.length = "00:00:01.0"
    @exersice.get_hr_at("2010-01-01T11:59:59Z").should be == 110
  end
 
  it "should give last hr point when request is after traning has ended" do
    @exersice.hr_data = [110, 111]
    @exersice.length = "00:00:01.0"
    @exersice.get_hr_at("2010-01-01T12:00:05Z").should be == 111
  end
  it "should be able to decide hr on intervall basis" do
    @exersice.hr_data = [1,2,3]
    @exersice.length = "00:00:10.0"
    @exersice.get_hr_at("2010-01-01T12:00:00Z").should be == 1
    @exersice.get_hr_at("2010-01-01T12:00:05Z").should be == 2
    @exersice.get_hr_at("2010-01-01T12:00:10Z").should be == 3
  end
end
