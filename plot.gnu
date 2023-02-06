set terminal svg noenhanced size 1500,900

set key below offset 0,-0.5

set ylabel "Edits"
set xlabel "Month" offset 0,1


set xtics rotate by 90 right

set datafile separator tab


###############

#set output "plot.svg"
#
#set datafile missing '0'
#plot for [col=2:8] "out/enwiki.tsv" using 0:col:xtic(1) title columnheader with lines


###############

set output OUTPUT

set datafile missing

# in reverse order, fill the area below current column
#plot for [col=8:2:-1] INPUT using 0:(column(col)>0 ? (sum [i=2:col] column(i)) : ""):xtic(1) title columnheader(col) with filledcurves x1
# fill the area between stacked lines for current column and previous column
set style textbox opaque noborder
stackedlines(col) = sum [i=2:col] valid(i) ? column(i) : 0
percent(col) = ceil( 100.0 * column(col) / stackedlines(8) )
plot \
	for [col=2:8] INPUT using 0:(stackedlines(col)):(stackedlines(col-1)):xtic(1) title columnheader(col)[0:15] with filledcurves, \
	for [col=2:8] INPUT every 6 using ( 6*column(0)-1 ):( stackedlines(col)/2 + stackedlines(col-1)/2 ):( sprintf("%d%%", percent(col)) ) with labels notitle boxed


###############

#set output "plotstackedbar.svg"
#
#set style data histograms
#set style histogram rowstacked
#set boxwidth 1 relative
#set style fill solid 1.0 border -1
#
#plot for [col=2:8] "out/enwiki.tsv" using col:xtic(1) title columnheader

