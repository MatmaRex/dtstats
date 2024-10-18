def get_command db, file
	mysql = "analytics-mysql #{db}"
	ssh = "ssh stat1009.eqiad.wmnet \"#{mysql}\""

	# command = "echo #{sql.gsub "\n", ' '} | #{ssh}"
	command = "#{ssh} <#{file}"

	command
end

if $0 == __FILE__
	puts `#{get_command *ARGV}`
end
