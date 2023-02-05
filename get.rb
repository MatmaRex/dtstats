require './query.rb'

wikis = File.readlines "C:/mediawiki/operations/mediawiki-config/dblists/large.dblist"
wikis = wikis.map(&:strip).reject{|a| a =~ /#/ }

wikis.each do |db|
	puts `#{get_command db, 'dt-usage-growth.sql'} >out/#{db}-raw.tsv`
	`datamash --header-in crosstab 1,2 sum 3 <out/#{db}-raw.tsv >out/#{db}.tsv`

	# fix order
	`datamash transpose <out/#{db}.tsv >out/#{db}-tmp.tsv`
	order = ["", 'discussiontools', 'mobile edit', 'wikieditor', 'NULL']
	lines = File.readlines "out/#{db}-tmp.tsv"
	lines = lines.sort_by{|ln| [order.index(ln.split("\t")[0]) || 99, ln] }
	File.write "out/#{db}-tmp.tsv", lines.join('')
	`datamash transpose >out/#{db}.tsv <out/#{db}-tmp.tsv`
	`rm out/#{db}-tmp.tsv`
end
