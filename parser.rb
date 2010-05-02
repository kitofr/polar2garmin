require 'date'
require 'fileutils'
require 'exersice'

Process.exit unless $0 == __FILE__

if ARGV.length < 1
  puts "Usage: ruby parser [path to hrm file]"
  Process.exit
end
file = ARGV[0]

puts "HRM File: #{file}"
exersice = ExersiceBuilder.build(File.open(file, "r").read)
puts exersice.summary

