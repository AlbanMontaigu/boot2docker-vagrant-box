#!/usr/bin/env bats

# Given i'm already in a Vagrantfile-ized folder
# And the basebox has already been added to vagrant

@test "Vagrant up is working with basic settings" {
	# Ensure the VM is stopped
	run vagrant stop
	run vagrant destroy -f
	run vagrant box remove --force --provider virtualbox --box-version ${B2D_BOX_VERSION} ${ATLAS_USERNAME}/${ATLAS_NAME}
	m4 Vagrantfile.m4 > Vagrantfile
	vagrant up --provider=virtualbox
	[ $( vagrant status | grep 'running' | wc -l ) -ge 1 ]
}

@test "Vagrant can ssh to the VM" {
	vagrant ssh -c 'echo OK'
}

@test "Default ssh user has sudoers rights in the VM" {
	[ "$(vagrant ssh -c 'sudo whoami' -- -n -T | tail -n1)" == "root" ]
}

@test "Docker client exists in the VM" {
	vagrant ssh -c 'which docker'
}

@test "Docker is working inside the VM " {
	vagrant ssh -c 'docker ps'
}

DOCKER_TARGET_VERSION=${B2D_VERSION}
@test "Docker is version DOCKER_TARGET_VERSION=${DOCKER_TARGET_VERSION} in the VM" {
	DOCKER_VERSION=$(vagrant ssh -c "docker version --format '{{.Server.Version}}'" -- -n -T | tail -n1)
	[ "${DOCKER_VERSION}" == "${DOCKER_TARGET_VERSION}" ]
}

@test "My bootlocal.sh script should have been run at boot" {
	[ $(vagrant ssh -c 'grep OK /tmp/token-boot-local | wc -l' -- -n -T | tail -n1) -eq 1 ]
}

@test "Container hello-world is pulled properly in the VM" {
	vagrant ssh -c 'docker pull hello-world'
}

@test "Container hello-world runs properly in the VM" {
    HELLO_WORLD_MSG_N1=$(vagrant ssh -c 'docker run hello-world' -- -n -T | sed -n 3p)
	[ "${HELLO_WORLD_MSG_N1}" == "Hello from Docker!" ]
}

@test "The VM can be properly rebooted" {
	vagrant reload
	vagrant ssh -c 'echo OK'
}

@test "Local files are shared in /vagrant in the VM" {
    vagrant ssh -c 'ls /vagrant/boot2docker_vagrant_virtualbox.bats'
}

@test "Rsync is installed inside the remote VM" {
	vagrant ssh -c "which rsync"
}

@test "A folder can be shared thru rsync" {
	sed -i -e 's/#SYNC_TOKEN/config.vm.synced_folder ".", "\/vagrant", type: "rsync"/g' Vagrantfile
	vagrant reload
	[ $( vagrant status | grep 'running' | wc -l ) -ge 1 ]
	vagrant ssh -c "ls -l /vagrant/Vagrantfile"
}

@test "The VM can be stopped properly" {
	vagrant halt
}

@test "The VM can be destroyed properly" {
	vagrant destroy -f
}
