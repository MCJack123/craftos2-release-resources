#
# Regular cron jobs for the craftos-pc-data package
#
0 4	* * *	root	[ -x /usr/bin/craftos-pc-data_maintenance ] && /usr/bin/craftos-pc-data_maintenance
