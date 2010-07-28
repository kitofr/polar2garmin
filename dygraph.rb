require 'rubygems'
require 'lib/exersice'


@exersice = Exersice.new
@exersice.date("20100729", "00:00:00.0")
@exersice.hr_data = [110, 120, 145, 180, 155, 145, 115]
@exersice.length = "00:00:10.0"
@exersice.sample_interval = 5
@data = "'Time,Heart Rate\\n' + \n"

(Time.parse("2010-07-29T00:00:00")..Time.parse("2010-07-29T00:00:35")).each do |time|
  formatted = time.strftime("%Y-%m-%dT%H:%M:%SZ")
#  puts formatted
  @data += "'#{time},#{@exersice.get_heart_rate_at(formatted)}\\n' + \n"
end

@data.rstrip!.chop!

html = <<EOS
<html>
<head>
<script type="text/javascript"
  src="js/dygraph-combined.js"></script>
</head>
<body>
<div id="graphdiv"></div>
<script type="text/javascript">
  g = new Dygraph(

    // containing div
    document.getElementById("graphdiv"),

    // CSV or path to a CSV file.
    #{@data}
  );
</script>
</body>
</html>
EOS

puts html
