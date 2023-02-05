files = []

Dir.entries('out').each do |d|
	next if d == '.' || d == '..'
	next if d =~ /raw/
	`gnuplot -e INPUT='out/#{d}' -e OUTPUT='plot/#{d}.svg' plot.gnu`
	files << d.sub('.tsv', '')
end


html = ""

html += '<ul style="position:fixed; top:0; right:0;">'
html += files.map{|f|
	"<li><a href='##{f}'>#{f}</a></li>"
}.join("\n")
html += '</ul>'

html += files.map{|f|
	"<h2 id='#{f}'>#{f}</h2><img src='#{f}.tsv.svg'>"
}.join("\n")

File.write "plot/index.html", html
