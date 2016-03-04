# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "esyscmd(echo -n $ATLAS_USERNAME/$ATLAS_NAME)"
  config.vm.box_version = "esyscmd(echo -n $B2D_VERSION)"
  
  # SYNC_TOKEN
  config.vm.provision "shell", path: "bootlocal.sh", run: "always"

end
