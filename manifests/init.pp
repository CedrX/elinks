#init.pp
class elinks {
	$elinks_fileconf = $::osfamily ? {
		'Debian'	=> '/etc/elinks/elinks.conf',
		'RedHat'	=> '/etc/elinks.conf'
	}
	
	package { "elinks" :
                      ensure => present,
                      require => Class[packetmanager]
        }
	
	if $::global_proxyport !="" {
        exec { "set_proxy_for_elinks":
                path => "/usr/bin:/usr/sbin:/bin",
                command => "echo \"set protocol.http.proxy.host = \\\"$::global_proxyhost:$::global_proxyport\\\" \" >> $elinks_fileconf",
                 unless => "grep -q 'http\\.proxy\\.host' $elinks_fileconf",
                 require => Package["elinks"]
            }
	Package['elinks'] -> Exec['set_proxy_for_elinks']


	}
}
