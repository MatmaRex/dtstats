#!/usr/bin/ruby
files = []

Dir.entries('out').sort.each do |d|
	next if d == '.' || d == '..'
	next if d =~ /raw/
	`gnuplot -e INPUT='out/#{d}' -e OUTPUT='plot/#{d}.svg' plot.gnu`
	files << d.sub('.tsv', '')
end


html = '<h1>Usage stats for DiscussionTools and other methods of adding talk page comments</h1>
<p><strong><a href="https://github.com/MatmaRex/dtstats/blob/master/README.md">Notes and caveats</a></strong></p>
<p><a href="./data.tgz">Raw data (TSV)</a> &bull; <a href="https://github.com/MatmaRex/dtstats">Source code</a></p>
'

html += '<ul style="position:fixed; top:0; right:0;">'
html += files.map{|f|
	"<li><a href='##{f}'>#{f}</a></li>"
}.join("\n")
html += '</ul>'

html += files.map{|f|
	"<h2 id='#{f}'>#{f}</h2><img src='#{f}.tsv.svg'>"
}.join("\n")

File.write "plot/index.html", html
`tar -zcf plot/data.tgz out`
