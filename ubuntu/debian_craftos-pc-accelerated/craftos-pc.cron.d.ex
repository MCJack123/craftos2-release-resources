#
# Regular cron jobs for the craftos-pc package
#
0 4	* * *	root	[ -x /usr/bin/craftos-pc_maintenance ] && /usr/bin/craftos-pc_maintenance
