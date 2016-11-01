# -*- mode: ruby -*-
# vi: set ft=ruby :


# ==========================================
# General conf, change here
# ==========================================
B2D_SHARED_DIR_HOST = "."
B2D_SHARED_DIR_VM = "/vagrant"

# Default value if not set
unless defined? B2D_SHARED_DIR_TYPE
  B2D_SHARED_DIR_TYPE = ""
end


# ==========================================
# Virtual host configuration
# ==========================================
Vagrant.configure("2") do |config|


  # -----------------------------------
  # User connection in the box
  # -----------------------------------
  config.ssh.shell = "sh"
  config.ssh.username = "docker"

  # Used on Vagrant >= 1.7.x to disable the ssh key regeneration
  config.ssh.insert_key = false


  # -----------------------------------
  # Folder share activation
  # -----------------------------------
  puts case B2D_SHARED_DIR_TYPE
  when "NFS"
    config.vm.synced_folder B2D_SHARED_DIR_HOST, B2D_SHARED_DIR_VM, type: "nfs", mount_options: ["nolock", "vers=3", "udp"], id: "nfs-sync"
  when "RSYNC"
    config.vm.synced_folder B2D_SHARED_DIR_HOST, B2D_SHARED_DIR_VM, type: "rsync", rsync__auto: true
  else
    # Default vb guest additions
    config.vm.synced_folder B2D_SHARED_DIR_HOST, B2D_SHARED_DIR_VM
  end


  # -----------------------------------
  # Virtualbox specific configuration
  # -----------------------------------
  config.vm.provider "virtualbox" do |vm|
    vm.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  
  # -----------------------------------
  # Expose the Docker ports
  # -----------------------------------
  config.vm.network "forwarded_port", guest: 2375, host: 2375, host_ip: "127.0.0.1", auto_correct: true, id: "docker"
  config.vm.network "forwarded_port", guest: 2376, host: 2376, host_ip: "127.0.0.1", auto_correct: true, id: "docker-ssl"

end
