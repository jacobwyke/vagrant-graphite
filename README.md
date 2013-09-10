Vagrant Graphite
================

Vagrant VM for an Ubuntu Precise (12.04) box running graphite.

#Config#
There are some config options available in 'vagrant.config.rb' which allow you to easily change the IP address the VM uses.

#Installation#
Run:

	vagrant up

Go to: [http://10.0.1.100](http://10.0.1.100)
	
Virtual machine defaults to 10.0.1.100.

If you get a server 500 message when attempting to view graphite try to provision the VM again with:

	vagrant provision
	
#Adding Data#
To add test data you can run the graphite example client which can be found at '/opt/graphite/examples/example-client.py'

	vagrant ssh
	
	/opt/graphite/examples/example-client.py
	
This will add system load values every 60 seconds.

You can post your own data to port 2003 or look to use something like StatsD.

The format of the data you post is:

	<stat name> <value> <time>\n
	
	system.loadavg_1min 0.04 1378814122\n
