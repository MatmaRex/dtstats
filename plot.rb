#!/usr/bin/ruby
files = []

Dir.entries('out').sort.each do |d|
	next if d == '.' || d == '..'
	next if d =~ /raw/
	`gnuplot -c plot.gnu out/#{d} plot/#{d}.svg`
	files << d.sub('.tsv', '')
end

toc = files.map{|f|
	"<li><a href='##{f}'>#{f}</a></li>"
}.join("\n")

graphs = files.map{|f|
	"<h2 id='#{f}'>#{f}</h2>\n<img src='#{f}.tsv.svg'>"
}.join("\n\n")

html = <<-HTML
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>DiscussionTools stats</title>
</head>
<body>
<h1>Usage stats for DiscussionTools and other methods of adding talk page comments</h1>
<p><strong><a href="https://github.com/MatmaRex/dtstats/blob/master/README.md">Notes and caveats</a></strong></p>
<p><a href="./data.tgz">Raw data (TSV)</a> &bull; <a href="https://github.com/MatmaRex/dtstats">Source code</a></p>

<ul style="position:fixed; top:0; right:0;">
#{toc}
</ul>

#{graphs}
</body>
</html>
HTML


File.write "plot/index.html", html
`tar -zcf plot/data.tgz out`
