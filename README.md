# Linux Yocto OS For Orange Pi R1+

This codebase is used to generate a full OS image for Orangepi R1+ boards, with support
for Docker and K3S (Kubernetes).

It is maintained by independent developers and aims at providing an easy-to-use Linux distribution 
for Orange Pi R1+ boards that can be used for something else than a router.

## What is the Orange Pi R1+ ??

First of all, here is the documentation about this board: [Orange Pi R1+ LTS](http://www.orangepi.org/html/hardWare/computerAndMicrocontrollers/details/orange-pi-R1-Plus-LTS.html)  


`What is the initial objective of this dev kit?`: This kit is meant to be a small router, using OpenWRT.  

`Why was this dev kit chosen?`: because it does not cost much (about 50$ at the time of writing this), and provides interesting performances. Here are the main specs:
- Quad-core Cortex-A53 64-Bit CPU  
- Mali-450MP2 GPU, for tablet-grade graphics  
- 1 GB LPDDR3 Memory  
- 13pin headers for GPIOs, I2C, audio and display!  
- USB-C powered  
- Dual Gigabit Ethernet Ports  

In summary, it has everything we need to make it a valid replacement for a Raspberry Pi!  

## Quick Start Guide

Follow these steps to get up and running with your Orangepi R1+!  

### Hardware you should have with you

1. A Debian or Ubuntu Computer (documentation for Windows is not done yet)
2. An Orange Pi R1+ \[LTS\] (of course!)    
![Orangepi R1+ Image](doc/orangepir1-pluslts.png)  
3. A USB-c cable/charger for powering up the device  
4. A SD card, with a capacity of 16GB or higher  
5. A USB to SD adapter  
6. [Optional] A UART to USB Adapter that can reach communication speeds of 1500000bds, such as "DTECH 6ft 3.3V FTDI USB to TTL Serial"  
![FTDI Cable](doc/ftdi-example.jpg)  

### Preparing Your Computer

Run the following commands in a terminal to setup your computer:  

```
$ sudo apt update
$ sudo apt install bmaptool ssh
```

### Preparing the SD Card

> **_NOTE:_** The following steps are for a Debian/Ubuntu Linux computer. It can be done on Windows too, but you will have to find the equivalent!  

The SD Card of the Orange Pi R1+ is the main storage of the device. If you already used a Raspberry Pi before, you should be used to this, as it is used the same way.  

Here are the steps to follow:  

1. Download the latest `wic.gz` and `wic.bmap` files from [the release section of this github repository](https://github.com/aledemers/yocto-orangepi-r1plus/releases)  
2. Insert the SD card in the SD to USB adapter  
3. Open a terminal were you downloaded the files  
4. Connect your USB to SD adapter in your computer  
5. Find the path to your SD card by typing the following command:  
```
$ sudo dmesg

[78214.923180] EXT4-fs (sdb3): mounting ext2 file system using the ext4 subsystem
[78214.927112] EXT4-fs (sdb3): warning: mounting unchecked fs, running e2fsck is recommended
[78214.931422] EXT4-fs (sdb3): mounted filesystem without journal. Opts: errors=remount-ro. Quota mode: none.
[78214.991563] EXT4-fs (sdb4): recovery complete
[78214.991569] EXT4-fs (sdb4): mounted filesystem with ordered data mode. Opts: errors=remount-ro. Quota mode: none.
```
6. In the log above, you can see `sdb` mentioned a few times, indicating the SD card is `sdb`. The path is then: `/dev/sdb`  
7. Open a Linux terminal in the folder where you downloaded `wic` files at step 1, then run the following commands to program the SD card:  
```
$ BMAP_FILE=orangepi-docker-image-orangepi-r1plus-lts.wic.bmap
$ THE_WIC_GZ_FILE=orangepi-docker-image-orangepi-r1plus-lts.wic.gz
$ SD_CARD_PATH=/dev/sdX       # Replace sdX by the previously found label (sdb in the example)
$ sudo umount "${SD_CARD_PATH}"/*
$ sudo bmaptool copy --bmap "${THE_BMAP_FILE}" "${THE_WIC_GZ_FILE}" "${SD_CARD_PATH}"
```
8. Once the commands succeeds, you can remove the SD card

### Booting the board

Your SD Card is now ready to launch!  

1. Insert the SD card previously programmed in your `Orange Pi R1+` board  
2. Power it on using the USB-C Cable or charger  
3. After a few seconds, the dev kit's green LED should light solid ON, and the redlight should do periodic quick double flashes. If it does not, there is an issue! Redo the steps, or use the UART to USB cable to debug... TODO: write this documentation  
4. You can now connect a network cable to one of the Ethernet port, and watch the network status lights flash!  
5. You can connect to the Orange Pi board using SSH, after finding its IP address (use your router's web page to find the IP):  

```
$ ssh root@IP_ADDRESS
passwd: root
```

### Use your dev kit!

#### Customizing your device

The whole filesystem is writable, so you can customize your device as you wish. Note that there is no configured package manager (like apt-get), as we did not bring up any yet.
If you want to install more software than what is on your device, either use [docker](https://www.docker.com/), or compile it from sources. You have compilers available, and even git :)  

#### Updating your device to a newer version of BlinkOS

This is as easy as: repeat the installation steps from [Preparing the SD Card](#Preparing the SD Card)! All data stored in `/home/root`, `/data` and 
`/var/lib/docker` will be kept throughout updates, but all the rest is going to be wiped off.

Be careful to store your precious projects in one of these locations!

# Developers Documentation

This part of the documentation is for advanced users that would like to compile the Linux image themselves  

## Requirements

- Docker  
- bmaptool  
- git  

## Setup

```
$ git clone https://github.com/aledemers/yocto-orangepi-r1plus.git
$ git submodule update --init
$ ./shell.sh
```

## Build Docker Image For Orange Pi R1+

```
$ MACHINE=orangepi-r1plus-lts bitbake orangepi-docker-image
```

## Flashing the SD card

1. Find the output SD Card image:  
```
build/tmp/deploy/images/orangepi-r1plus/IMAGE_NAME.wic.gz  
```
2. Insert the SD card to be programmed in your computer.  
3. Flash the image. In the command below:
    - Replace sdX by your SD card identifier (e.g.: sdb):  
    - Replace IMAGE_NAME by the name of the file found in the previous step  
```
sudo bmaptool copy --bmap build/tmp/deploy/images/orangepi-r1plus/IMAGE_NAME.wic.bmap build/tmp/deploy/images/orangepi-r1plus/IMAGE_NAME.wic.gz /dev/sdX  
```
4. Remove the SD card from your computer, insert it in your orangepi-r1+, and watch it boot!  
5. UART console access will be provided on the 3-pins header beside the USB connector, baudrate=1500000 (see user orangepi r1+ user manual for more information about debug UART header)  
