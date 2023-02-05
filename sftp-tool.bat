echo put plot/* | sftp -b - -s "sudo -u tools.dtstats /usr/lib/sftp-server" matmarex@login.toolforge.org:/data/project/dtstats/public_html
