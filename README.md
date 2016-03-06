# boot2docker-vagrant-box [![Circle CI](https://circleci.com/gh/AlbanMontaigu/docker-compose.svg?style=shield)](https://circleci.com/gh/AlbanMontaigu/boot2docker-vagrant-box)

## Introduction

Forked from [dduportal/boot2docker-vagrant-box](https://github.com/dduportal/boot2docker-vagrant-box), thanks Damien !

My fork is a simplier version (no parallels support) with my personal touch.

This repository contains the scripts necessary to create a Vagrant compatible [boot2docker](https://github.com/boot2docker/boot2docker) box.

If you work solely with Docker, this box lets you keep your Vagrant workflow and work in the most minimal Docker environment possible.

## Usage

The box is available on [Hashicrop's Atlas](https://atlas.hashicorp.com/AlbanMontaigu/boxes/boot2docker), making it very easy to use it:
* Download and include the proposed [vagrant template](https://github.com/AlbanMontaigu/boot2docker-vagrant-template) in your project
* Run your environment with  ```vagrant up```

If you want the actual box source file, you can download it from the [release page](https://github.com/AlbanMontaigu/boot2docker-vagrant-box/releases).

## Network considerations

By default, we use a NAT interfaces, which have its ports 2375 and 2376 (Docker IANA ports) forwarded to the loopback (localhost) of your physical host.

## Customization

If you want to tune contents, you can see how to achieve this with somthing like [vagrant template](https://github.com/AlbanMontaigu/boot2docker-vagrant-template).

## Building the Box

If you want to recreate the box, rather than using the binary, then you can use the scripts and Packer template within this repository to do so in seconds.

To build the box, first install the following prerequisites:

  * [Make as workflow engine](http://www.gnu.org/software/make/)
  * [Packer as vagrant basebox builder](http://www.packer.io) (at least version 0.7.5)
  * [VirtualBox](http://www.virtualbox.org) (at least version 4.3.28)
  * [curl for downloading things](http://curl.haxx.se)
  * [bats for testing](https://github.com/sstephenson/bats)

Then run this command to build the box for VirtualBox provider:

```
make virtualbox
```
