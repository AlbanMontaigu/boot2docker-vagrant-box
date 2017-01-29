#!/usr/bin/env bats

# Given i'm already in a Vagrantfile-ized folder
# And the basebox has already been added to vagrant

@test "We can vagrant up the VM with basic settings" {
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

@test "Default ssh user has sudoers rights" {
	[ "$(vagrant ssh -c 'sudo whoami' -- -n -T | tail -n1)" == "root" ]
}

@test "Docker client exists in the remote VM" {
	vagrant ssh -c 'which docker'
}

@test "Docker is working inside the remote VM " {
	vagrant ssh -c 'docker ps'
}

DOCKER_TARGET_VERSION=${B2D_VERSION}
@test "Docker is version DOCKER_TARGET_VERSION=${DOCKER_TARGET_VERSION}" {
	DOCKER_VERSION=$(vagrant ssh -c "docker version --format '{{.Server.Version}}'" -- -n -T | tail -n1)
	[ "${DOCKER_VERSION}" == "${DOCKER_TARGET_VERSION}" ]
}

@test "My bootlocal.sh script, should have been run at boot" {
	[ $(vagrant ssh -c 'grep OK /tmp/token-boot-local | wc -l' -- -n -T | tail -n1) -eq 1 ]
}

@test "Container hello-world runs properly" {
    HELLO_WORLD_MSG_N1=$(vagrant ssh -c 'docker run hello-world' -- -n -T | tail -n1)
	[ "${HELLO_WORLD_MSG_N1}" == "This message shows that your installation appears to be working correctly." ]
}

@test "We can reboot the VM properly" {
	vagrant reload
	vagrant ssh -c 'echo OK'
}

@test "Rsync is installed inside the b2d" {
	vagrant ssh -c "which rsync"
}

@test "We can share folder thru rsync" {
	sed -i -e 's/#SYNC_TOKEN/config.vm.synced_folder ".", "\/vagrant", type: "rsync"/g' Vagrantfile
	vagrant reload
	[ $( vagrant status | grep 'running' | wc -l ) -ge 1 ]
	vagrant ssh -c "ls -l /vagrant/Vagrantfile"
}

@test "I can stop the VM" {
	vagrant halt
}

@test "I can destroy the VM" {
	vagrant destroy -f
}
