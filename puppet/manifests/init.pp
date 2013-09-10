#Variables
$hostName = 'graphite.local'

#DONT EDIT PAST THIS POINT

if ! $::osfamily {
  case $::operatingsystem {
    'RedHat', 'Fedora', 'CentOS', 'Scientific', 'SLC', 'Ascendos', 'CloudLinux', 'PSBM', 'OracleLinux', 'OVS', 'OEL': {
      $osfamily = 'RedHat'
    }
    'ubuntu', 'debian': {
      $osfamily = 'Debian'
    }
    'SLES', 'SLED', 'OpenSuSE', 'SuSE': {
      $osfamily = 'Suse'
    }
    'Solaris', 'Nexenta': {
      $osfamily = 'Solaris'
    }
    default: {
      $osfamily = $::operatingsystem
    }
  }
}

class repository {	
	#Refresh the list of packages
	exec { 'apt-get-update':
		command => 'apt-get update',
		path    => ['/bin', '/usr/bin'],
	}

	#add the add-apt-repository binary
	package { 'python-software-properties':
		ensure => latest,
		require => [
			Exec['apt-get-update'],
		]
	}
}

class system {
	#set the timezone to UTC
	class { 'timezone': timezone => 'UTC', }

	#set /etc/hosts
	host { $hostName:
		ip 	=> '127.0.0.1',
		name 	=> $hostName,
		ensure	=> 'present',
	}
}

class graphite {
	file { '/vagrant/puppet/files/setup.sh':
		mode 	=> '0755',	
	}
	
	exec { 'setup':
		command => '/vagrant/puppet/files/setup.sh',
		path    => ['/bin', '/usr/bin'],
		returns	=> 1,
		require	=> [
			File['/vagrant/puppet/files/setup.sh'],
		]
	}
}

stage { 
	pre: before => Stage[main] 
}
 
class { 'repository':
	stage => pre
}

include system
include graphite