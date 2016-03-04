# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Configuration
  B2D_SHARED_DIR_HOST = "."
  B2D_SHARED_DIR_VM = "/vagrant"
  B2D_SHARED_DIR_TYPE = "RSYNC"
  B2D_SHARED_DIR_OPTIONS = ""

  # User connection in the box
  config.ssh.shell = "sh"
  config.ssh.username = "docker"

  # Used on Vagrant >= 1.7.x to disable the ssh key regeneration
  config.ssh.insert_key = false

  # Folder share options management
  puts case B2D_SHARED_DIR_TYPE
  when "NFS"
    B2D_SHARED_DIR_OPTIONS = ", type: \"nfs\", mount_options: [\"nolock\", \"vers=3\", \"udp\"], id: \"nfs-sync\""
  when "RSYNC"
    B2D_SHARED_DIR_OPTIONS = ", type: \"rsync\", rsync__auto: true"
  else
    # No options
  end

  # Folder share activation
  config.vm.synced_folder B2D_SHARED_DIR_HOST, B2D_SHARED_DIR_VM B2D_SHARED_DIR_OPTIONS

  # Virtualbox configuration
  config.vm.provider "virtualbox" do |v, override|
    # Expose the Docker ports (non secured AND secured)
    override.vm.network "forwarded_port", guest: 2375, host: 2375, host_ip: "127.0.0.1", auto_correct: true, id: "docker"
    override.vm.network "forwarded_port", guest: 2376, host: 2376, host_ip: "127.0.0.1", auto_correct: true, id: "docker-ssl"
  end

end
