require 'rubygems'
require 'lib/exersice'


@exersice = Exersice.new
@exersice.date("20100729", "00:00:00.0")
@exersice.hr_data = [110, 120, 145, 160, 155, 165, 150, 145, 115]
@exersice.length = "00:00:45.0"
@exersice.sample_interval = 5
@data = "'Time,Heart Rate,Altitude\\n' + \n"

(Time.parse("2010-07-29T00:00:00")..Time.parse("2010-07-29T00:00:50")).step(4) do |time|
  formatted = time.strftime("%Y-%m-%dT%H:%M:%SZ")
#  puts formatted
  @data += "'#{time},#{@exersice.get_heart_rate_at(formatted)}, #{@exersice.get_heart_rate_at(formatted) - rand(20)}\\n' + \n"
end

@data.rstrip!.chop!

html = <<EOS
<html>
<head>
  <script type="text/javascript" src="js/dygraph-combined.js"></script>
  <style type="text/css">
    body 
    { 
      font-family: sans-serif;
    }
  </style>
</head>
<body>
<div id="graphdiv"></div>
<script type="text/javascript">
  g = new Dygraph(

    // containing div
    document.getElementById("graphdiv"),

    // CSV or path to a CSV file.
    #{@data},
    {
      drawPoints: true,
      pointSize: 4,
      strokeWidth: 2,
      highlightCircleSize: 6,
      axisLabelFontSize: 10,
      rightGap: 15,
      fillGraph: true
    }
  );
</script>
</body>
</html>
EOS

puts html
