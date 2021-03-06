Vagrant Graphite
================

[Vagrant](http://www.vagrantup.com/) VM for an Ubuntu Precise (12.04) box running [Graphite](http://graphite.wikidot.com/).

This will launch a virtual machine running [Graphite](http://graphite.wikidot.com/), the scalable realtime graphing software. All you have to do is feed it your data and make your graphs.

Tested with Vagrant 1.3.1.

#Config#
There are some config options available in '[vagrant.config.rb](https://github.com/jacobwyke/vagrant-graphite/blob/master/vagrant.config.rb)' which allow you to easily change the IP address the VM uses.

All config variables are exaplained in '[vagrant.config.rb](https://github.com/jacobwyke/vagrant-graphite/blob/master/vagrant.config.rb)'.

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

You can post your own data to port 2003 or look to use something like [StatsD](https://github.com/etsy/statsd/).

The format of the data you post is:

	<stat name> <value> <time>\n
	
	system.loadavg_1min 0.04 1378814122\n

An example using netcat:

	echo "local.test 4 `date +%s`" | nc 10.0.1.100 2003