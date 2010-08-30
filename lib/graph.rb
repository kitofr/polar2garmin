require 'rubygems'
require 'gruff'

def stats
  g = Gruff::Line.new('580x210')
  g.theme = {
    :colors => ['#ff6600', '#3bb000', '#1e90ff', '#efba00', '#0aaafd'],
    :marker_color => '#aaa',
    :background_colors => ['#eaeaea', '#fff']
  }

  g.title = "My Graph" 
  
  g.data("Apples", [1, 2, 3, 4, 4, 3])
  g.data("Oranges", [4, 8, 7, 9, 8, 9])
  g.data("Watermelon", [2, 3, 1, 5, 6, 8])
  g.data("Peaches", [9, 9, 10, 8, 7, 9])
  
  g.labels = {0 => '2003', 2 => '2004', 4 => '2005'}
  
  g.write('stats.png')


  #g.hide_title = true
  #g.font = File.expand_path('path/to/font.ttf', RAILS_ROOT)

#  range = "created_at #{(12.months.ago.to_date..Date.today).to_s(:db)}"
#  @users = User.count(:all, :conditions => range, :group => "DATE_FORMAT(created_at, '%Y-%m')", :order =>"created_at ASC")
#  @votes = Vote.count(:all, :conditions => range, :group => "DATE_FORMAT(created_at, '%Y-%m')", :order =>"created_at ASC")
#  @bookmarks = Bookmark.count(:all, :conditions => range, :group => "DATE_FORMAT(created_at, '%Y-%m')", :order =>"created_at ASC")
#
#  # Take the union of all keys & convert into a hash {1 => "month", 2 => "month2"...}
#  # - This will be the x-axis.. representing the date range
#  months = (@users.keys | @votes.keys | @bookmarks.keys).sort
#  keys = Hash[*months.collect {|v| [months.index(v),v.to_s] }.flatten]
#
#  # Plot the data - insert 0's for missing keys
#  g.data("Users", keys.collect {|k,v| @users[v].nil? ? 0 : @users[v]})
#  g.data("Votes", keys.collect {|k,v| @votes[v].nil? ? 0 : @votes[v]})
#  g.data("Bookmarks", keys.collect {|k,v| @bookmarks[v].nil? ? 0 : @bookmarks[v]})
#
#  g.labels = keys
#
#  send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "site-stats.png")
end
