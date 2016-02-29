#!/bin/bash

# This is the script that is used to create the cluster and nodes within.

#gcloud container --project "kubernetes-showcase" clusters create "kubernetes-showcase-1" --zone "europe-west1-b" --machine-type "n1-standard-1" --scope "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write" --num-nodes "5" --network "default" --enable-cloud-logging --no-enable-cloud-monitoring

mkdir -p ~/.puppet/modules
pushd  ~/.puppet/modules
git clone https://github.com/iMartyn/puppet-gce_compute_master.git gce_compute_master
git clone https://github.com/iMartyn/puppet-gce_example.git gce_example
popd

puppet module install puppetlabs-gce_compute

cat > `puppet apply --configprint deviceconfig` <<EOF
[kubernetes_showcase]
  type gce
  url [/dev/null]:kubernetes_showcase
EOF

puppet apply puppetmaster_up.pp
puppet apply cluster_up.pp
