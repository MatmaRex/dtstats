def get_sn db
	data = File.readlines "C:/mediawiki/operations/mediawiki-config/wmf-config/db-production.php"
	data = data.drop_while{|a| a !~ /sectionsByDB/ }.take_while{|a| a !~ /\]/ }
	data.find{|a| a =~ /'#{db}'/ }[/'s(\d+)'/, 1] rescue '3'
end

def get_command db, file
	sn = get_sn db
	mysql = "mysql --defaults-file=/etc/mysql/conf.d/analytics-research-client.cnf -h s#{sn}-analytics-replica.eqiad.wmnet -D #{db} -P 331#{sn} -A"
	ssh = "ssh stat1006.eqiad.wmnet \"#{mysql}\""

	# command = "echo #{sql.gsub "\n", ' '} | #{ssh}"
	command = "#{ssh} <#{file}"

	command
end

if $0 == __FILE__
	puts `#{get_command *ARGV}`
end
