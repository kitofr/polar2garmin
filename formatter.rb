require 'rexml/document'

Process.exit unless $0 == __FILE__

if ARGV.length < 1
  puts "Usage: ruby formatter.rb [xml-file-path]"
  Process.exit
end


file = File.new(ARGV[0])
doc = REXML::Document.new(file)
formatter = REXML::Formatters::Pretty.new(2)
formatter.write(doc, $stdout)

