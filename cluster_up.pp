    # manifests/site.pp
    # once set up, might want to remove http and be https-only
    gce_firewallrule { 'allow-http':
        ensure      => present,
        network     => 'default',
        description => 'Allows incoming http requests (unencrypted)',
        allow       => 'tcp:80',
    }
    gce_instance { 'www1':
        ensure       => present,
        description  => 'web server',
        machine_type => 'n1-standard-1',
        zone         => 'europe-west1-b',
        puppet_master => 'puppetmaster',
        puppet_service => present,
        maintenance_policy => 'migrate',
        network      => 'default',
        image        => 'debian-8',
        tags         => ['web'],
        startup_script => 'puppet-community.sh',
        puppet_manifest => '../../gce_example/manifests/webnode.pp',
        puppet_modules  => ['gce_example'],
        puppet_module_repos   => {
            'gce_example' => 'git://github.com/iMartyn/puppet-gce_example'
        }
    }
    $appnodes = ['1','2']
    each( $appnodes ) |$nodeid|{
        gce_instance { "app-${nodeid}":
            ensure       => present,
            description  => 'app server',
            machine_type => 'n1-standard-1',
            zone         => 'europe-west1-b',
            puppet_master => 'puppetmaster',
            puppet_service => present,
            maintenance_policy => 'migrate',
            network      => 'default',
            image        => 'debian-8',
            tags         => ['app'],
            startup_script => 'puppet-community.sh',
            puppet_manifest => '../../gce_example/manifests/appnode.pp'
        }
    }
    gce_httphealthcheck { 'basic-http':
        ensure       => present,
        require      => Gce_instance['www1'],
        description  => 'basic http health check',
    }
    gce_targetpool { 'www-pool':
        ensure       => present,
        require      => Gce_httphealthcheck['basic-http'],
        health_check => 'basic-http',
        instances    => {
            'europe-west1-b' => ['www1']
        },
        region       => 'europe-west1',
    }
    gce_forwardingrule { 'www-rule':
        ensure       => present,
        require      => Gce_targetpool['www-pool'],
        description  => 'Forward HTTP to web instances',
        port_range   => '80',
        region       => 'europe-west1',
        target_pool  => 'www-pool',
    }
