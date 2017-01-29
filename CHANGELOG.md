
## 1.13.0 (2017-01-29)
- UPDATE: Update to [boot2docker 1.13.0](https://github.com/boot2docker/boot2docker/releases/tag/v1.13.0)
- UPDATE: Update to packer 0.12.2 on circleci
- UPDATE: Readme updated
- BUGFIX: Remove test regarding make, m4, nfs since no more available as it in the box

## 1.12.6 (2017-01-19)
- UPDATE: Update to [boot2docker 1.12.6](https://github.com/boot2docker/boot2docker/releases/tag/v1.12.6) (thanks joehandwell)
- UPDATE: Atlas post processor removed since it may cause issues for some builds

## 1.12.5 (2016-12-26)
- UPDATE: Update to [boot2docker 1.12.5](https://github.com/boot2docker/boot2docker/releases/tag/v1.12.5)
- UPDATE: Update packer to 0.12.1 on circle ci

## 1.12.3 (2016-11-01)
- Update to [boot2docker 1.12.3](https://github.com/boot2docker/boot2docker/releases/tag/v1.12.3)
- Improved build custom iso process
- No nfs client started by default on bootlocal.sh
- Improved vagrantfile.tpl
- Option --natdnshostresolver1 set to on for virtualbox
- Improved template.json.m4
- Default vm disk size up to 100Go
- No more virtio option

## 1.12.2 (2016-10-25)
- Update to [boot2docker 1.12.2](https://github.com/boot2docker/boot2docker/releases/tag/v1.12.2)
- Build on atlas is no more alive since it became a paid service

## 1.12.1f (2016-09-19)
- Update to XORRISO 1.4.6 in image build tools
- M4 no more necessary now since it is loaded in docker-toolbox
- Make no more necessary now since it is loaded in docker-toolbox
- Added ```glibc-apps``` tcz to fix ```Vagrant was unable to mount VirtualBox shared folders``` issue due to missing ```getent``` and vagrant 1.8.5 incompatibility
- Now ```B2D_VERSION``` and ```B2D_BOX_VERSION``` should be fully separated

## 1.12.1 (2016-08-26)
- Update to [boot2docker 1.12.1](https://github.com/boot2docker/boot2docker/releases/tag/v1.12.1)

## 1.12.0 (2016-07-29)
- Update to [boot2docker 1.12.0](https://github.com/boot2docker/boot2docker/releases/tag/v1.12.0)

## 1.11.2 (2016-06-04)
- Update to [boot2docker 1.11.2](https://github.com/boot2docker/boot2docker/releases/tag/v1.11.2)
- Update to [packer 0.10.1](https://github.com/mitchellh/packer/releases/tag/v0.10.1)

## 1.11.0 (2016-04-14)
- Update to [boot2docker 1.11.0](https://github.com/boot2docker/boot2docker/releases/tag/v1.11.0)
- Update to [packer 0.10.0](https://github.com/mitchellh/packer/releases/tag/v0.10.0)
- Update to tinycore linux 7.x
- Now using failover url for tynicorelinux if main repo not available (as today...)

##  1.10.3 (2016-03-12)
- Update to [boot2docker 1.10.3](https://github.com/boot2docker/boot2docker/releases/tag/v1.10.3)

##  1.10.2 (2016-03-04)
- Update to [boot2docker 1.10.2](https://github.com/boot2docker/boot2docker/releases/tag/v1.10.2)
- Update to packer 0.9.0
- Rework of sharing system, now using ```B2D_SHARED_DIR_TYPE``` param and RSYNC by default to avoid virtualbox guest addition issue
- Bootlocal support removed, it must be be managed in final project to have a clear control, see [template project example](https://github.com/AlbanMontaigu/boot2docker-vagrant-template)

## 2016-02-12 (1.10.1)
- Update to [boot2docker 1.10.1](https://github.com/boot2docker/boot2docker/releases/tag/v1.10.1)

## 2016-02-05 (1.10.0)
- Update to [boot2docker 1.10.0](https://github.com/boot2docker/boot2docker/releases/tag/v1.10.0)

## 21/11/2015 (1.9.1)
- Update to [boot2docker 1.9.1](https://github.com/boot2docker/boot2docker/releases/tag/v1.9.1)
- Make added
- M4 added
- Circle CI integration
- Better testing
- TCZ package integration fixed

## 04/11/2015 (1.9.0)
- Update to [boot2docker 1.9.0](https://github.com/boot2docker/boot2docker/releases/tag/v1.9.0)

## 27/10/2015 (1.8.3)
- Update to [boot2docker 1.8.3](https://github.com/boot2docker/boot2docker/releases/tag/v1.8.3)
- Merge with dduportal
- Host only network removed
- Keep Virtualbox only

## 25/06/2015
- Moving boot2docker to [1.7.0](https://github.com/boot2docker/boot2docker/releases/tag/v1.7.0)

## 28/05/2015 (dduportal-1.6.2)
- Moving boot2docker to [1.6.2](https://github.com/boot2docker/boot2docker/releases/tag/v1.6.2)

## 13/05/2015 (dduportal-1.6.1)
- Moving boot2docker to [1.6.1](https://github.com/boot2docker/boot2docker/releases/tag/v1.6.1)
- GH-10 : Making NFS working, environment variable powered, documentation added
- Corrections around the Makefile for building yourself

## 04/05/2015 (dduportal-1.6.0)
- Moving boot2docker to [1.6.0](https://github.com/boot2docker/boot2docker/releases/tag/v1.6.0)

## 15/02/2015 (v1.5.0)
- GH-6 : Adding a private id to the default private network in order to permit bypass at user level
- Moving to [docker v1.5.0](https://github.com/docker/docker/blob/master/CHANGELOG.md#150-2015-02-10) + [boot2docker v1.5.0](https://github.com/boot2docker/boot2docker/releases/tag/v1.5.0) 
- Support of rsync synced folder (rsync is installed in the box)
- Removing the box-embedded iso (Is now dumped to the first partition of the HDD)
- Adding a set of integration tests usings bats for testing the box with the vagrant provider 

## 13/01/2015 (v1.4.1-2)
- GH-5 : NFS support for synced folder
- GH-5 : bootlocalh.sh is now working (from the vagrant synced folder)
- GH-5 : Vagrant 1.7 support : Disabling the new behaviour with ssh keys
- Adding a private network in order to ease NFS synced folder and access to VM services
- Writing some docs in order to use this VM as a remote daemon

## 17/12/2014 (v1.4.1)
- Moving to boot2docker 1.4.1 (and Docker 1.4.1)

## 25/11/2014 (v1.3.2)
- Moving to boot2docker 1.3.2 and Docker 1.3.2 (security issues)

## 07/11/2014 (v1.3.1)
- Moving to boot2docker 1.3.1 (docker 1.3.1)
- Adding SSL docker's daemon port NAT to 2376
- NATed ports are now auto-moved when conflicting
- Packer 0.7 compatibility
- When docker-building, AUFS limit is now 128 layers instead of 42
- Packer-only new build process, from the vanilla boot2docker iso, checksumed
- bootlocal.sh can be used from /vagrant mount (alongside the Vagrantfile)

## 13/07/2014 (v1.1.1)
- Moving to boot2docker 1.1.1 (and Docker 1.1.1 by transitivity)
- Persisting the b2d dependency into the make.sh script for easying future updates and trusting
- Moving the default RAM of the VM to 2Gb

## 05/07/2014 (v1.1.0)
- Moving to docker v1.1.0
- Moving to boot2docker v1.1.0
- Adding some error handling when building from shell

## 22/06/2014 (v1.0.1)
- Moving to docker and b2d 1.0.1

## 19/06/2014 (v1.0.0)
- Building b2d-vbox and b2d vagrant custom in one Dockerfile instead of Docker + vagrant + ubuntu
- Adding possibility to build boot2docker vanilla image from official github repo instead of pulling from Docker index
- Move to b2d and docker 1.0.0 (bash make.sh v1.0.0)

## 15/06/2014 (v0.5.0)
- Moving to the new IANA Docker port 2375, and let vagrant auto corrects when collision
- Moving to boot2docker and Docker 1.0.0 
- Using a custom Vagrantfile for building a b2d iso with vbox addition
- Re-using temporarly mitchellh vagrantfile + build-iso workflow for "vagranti-zing" the b2d.iso
- Updating build scripts (Unix/Windows) with packer building all types

## 08/05/2014 (v0.4.0)
- Adding auto Docker update
- Moving to Docker 0.11.1

## 07/05/2014 (v0.3.0)
- Adding linux build chain and bats tests
- Moving to official boot2docker build system
- Integrate boot2docker build into a Vagrant Docker provider
- Vboxsf build into ISO (auto) [4.3.8]

## 23/04/2014 (v0.2.0)
- Adding custom_profile mangement
- Adding Windows build chain
- Adding docker and vagrant BATS tests, Windows only

## 21/04/2014 (v0.1.0)

- Fetching latest version from mitchellh offical repository (results in using a vagrant cloud baebox with no docker)
- Updating b2d to experimental build with vboxsf inside (https://github.com/boot2docker/boot2docker/issues/282)
- Updating build-iso.sh to add a /etc/rc.d script for loading vboxsf module at boot.
- Updating basebox's vagrantfile template to enable /vagrant share
- Updating basebox's vagrantfile template to aut correct docker's TCP port when launching multiple VMs

## 03/03/2014

- Using misheska's ubuntu basebox for running docker easily.
- Attempts to install fig from orchardups.
