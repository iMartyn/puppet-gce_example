gce_instance { 'puppetmaster':
  ensure                => present,
  description           => 'Puppet Master Open Source',
  machine_type          => 'f1-micro',
  zone                  => 'europe-west1-b',
  network               => 'default',
  tags                  => ['puppet', 'master'],
  image                 => 'debian-8',
  puppet_manifest       => "../../gce_compute_master/manifests/init.pp",
  startup_script        => 'puppet-community.sh',
  puppet_service        => present,
  puppet_master         => "puppetmaster",
  puppet_modules        => ['puppetlabs-gce_compute', 'puppetlabs-inifile', 'puppetlabs-stdlib', 'puppetlabs-apt', 'puppetlabs-concat', 'saz-locales'],
  puppet_module_repos   => { 
    'puppetlabs-gce_compute' => "git://github.com/puppetlabs/puppetlabs-gce_compute",
    'gce_compute_master' => 'git://github.com/iMartyn/puppet-gce_compute_master',
    'gce_example' => 'git://github.com/iMartyn/puppet-gce_example'
  }
}
