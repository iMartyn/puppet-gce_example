class nginx ($version = "latest") {
    package {"nginx":
        ensure => $version, # Using the class parameter from above
    }
    file {"loadbalance-available":
        path => "/etc/nginx/sites-available/loadbalance",
        content => template("gce_example/loadbalance.erb"),
        notify => Service['nginx'],
        require => Package['nginx'],
    }
    file {'loadbalance-enabled':
        path => '/etc/nginx/sites-enabled/loadbalance',
        ensure => 'link',
        target => '/etc/nginx/sites-available/loadbalance',
        notify => Service['nginx'],
        require => File['loadbalance-available']
    }
    file {'default-enabled':
        path => '/etc/nginx/sites-enabled/default',
        ensure => 'absent',
        notify => Service['nginx'],
    }
    service {"nginx":
        ensure => running,
        enable => true,
        require => File["/etc/nginx/sites-enabled/loadbalance"],
    }
}
include nginx
