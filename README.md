# GCE Cluster Showcase

**Note:** This project is purely to show how puppet can be used to manage a simple two-tier cluster on google compute engine.  To test it out you will need to have already installed the [google-cloud-sdk](https://cloud.google.com/sdk) and authenticated against an account (gcloud init).

## Other Requirements
* Puppet 3.x
* --parser=future on the puppet command line or in your puppet config.

## Steps to provision

    puppet apply --parser=future puppetmaster_up.pp
* Wait for the master to completely provision before continuing
    puppet apply --parser=future cluster_up.pp
* Again wait for the nodes to provision.
    ./test.sh
* The above script is a somewhat fragile test to verify we are getting results from two end nodes.

## What does it do?

* Configures a puppetmaster server for the nodes to talk to (in the current version this appears to be not doing it's job as a puppetmaster, but my current experience with puppet is without a master, so I'm leaving it there as I have not the time I'd like to debug why.)
* Configures firewall rules to allow port 80 into the router of GCE
* Configures the forwarding rule and pool of 1 server to the www node (The requirement of this setup was to use nginx to load-balance)
* Configures an nginx load-balancer in round-robin mode (see what it doesn't do below.)
* Configures two "app tier" nodes to balance across and a sample application in GoLang

## What doesn't it do?

A whole lot that I would do in a production environment such as :
* Setting up an api on the web box, internally accessible only to add nodes to the pool dynamically OR
* Using puppetmaster (potentially with heira) to reconfigure the pool whenever config changes
* Dynamically adding nodes based on CPU usage or network traffic, to the appropriate tiers
* Use any kind of process management for the golang process, such as supervisord or systemd
* Allow for new code to be deployed.
* Set up a CI/CD environment - I'd use Jenkins but it's awkward to manage config - Groovy would be a good choice for this but time constraints...
* SSL (letsencrypt could fairly easily be added)
* iptables rules to compliment the firewall rules
* Separation of the app tier and web tier by routing
* Code on a read-only nfs share
* General security hardening

I think you get the idea... this is UNSUITABLE FOR PRODUCTION in it's current state, and if you don't know how to do all the things in this list or don't think of more, you should probably not be using this!  In fact, it's probably a pretty poor start even if you do, you have been warned!
