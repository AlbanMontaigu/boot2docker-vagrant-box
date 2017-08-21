# -*- mode: ruby -*-
# vi: set ft=ruby :


# ==========================================
# General conf, change here
# ==========================================

# Local share for project
B2D_SHARED_DIR_LOCAL_HOST = "."
B2D_SHARED_DIR_LOCAL_VM = "/vagrant"

# Default value for VAGRANT_HOME if not set
unless defined? VAGRANT_HOME
  VAGRANT_HOME = "~/.vagrant.d"
end

# Common share for all VM
B2D_SHARED_DIR_COMMON_HOST = "#{VAGRANT_HOME}/b2d_common"
B2D_SHARED_DIR_COMMON_VM = "#{B2D_SHARED_DIR_LOCAL_VM}/.vagrant/b2d_common"

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
    config.vm.synced_folder B2D_SHARED_DIR_LOCAL_HOST, B2D_SHARED_DIR_LOCAL_VM, type: "nfs", mount_options: ["nolock", "vers=3", "udp"], id: "nfs-sync"
    config.vm.synced_folder B2D_SHARED_DIR_COMMON_HOST, B2D_SHARED_DIR_COMMON_VM, type: "nfs", mount_options: ["nolock", "vers=3", "udp"], id: "nfs-sync", create: true
  when "RSYNC"
    config.vm.synced_folder B2D_SHARED_DIR_LOCAL_HOST, B2D_SHARED_DIR_LOCAL_VM, type: "rsync", rsync__auto: true
    config.vm.synced_folder B2D_SHARED_DIR_COMMON_HOST, B2D_SHARED_DIR_COMMON_VM, type: "rsync", rsync__auto: true, create: true
  else
    # Default vb guest additions
    config.vm.synced_folder B2D_SHARED_DIR_LOCAL_HOST, B2D_SHARED_DIR_LOCAL_VM
    config.vm.synced_folder B2D_SHARED_DIR_COMMON_HOST, B2D_SHARED_DIR_COMMON_VM, create: true
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
