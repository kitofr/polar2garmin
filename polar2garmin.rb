require 'rexml/document'
require 'exersice'

Process.exit unless $0 == __FILE__

include REXML
if ARGV.length != 2
  puts "Usage: ruby polar2garmin [path to hrm file] [path to gpx file]"
  Process.exit
end

hrm_file, gpx_file = ARGV

exersice = ExersiceBuilder.build(File.open(hrm_file, "r").read)

doc = REXML::Document.new(File.new(gpx_file))

doc.elements.each('//trkseg/trkpt') do |element|

  time = element.get_text('./time').value
  element.get_elements('./extensions/gpxtpx:TrackPointExtension').each do |ext|
    hr = Element.new 'gpxtpx:hr'
    hr.text = exersice.get_heart_rate_at(time)
    ext.add_element hr
  end
end

puts doc


