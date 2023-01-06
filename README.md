# Linux Yocto Orange Pi R1+ Build

Dev Kit Reference: [Orange Pi R1+](http://www.orangepi.org/html/hardWare/computerAndMicrocontrollers/details/orange-pi-R1-Plus-LTS.html)

This repository is an example Yocto build to generate custom Linux images for the Orange Pi R1+ Dev Kit.

## Requirements

- Docker  

## Setup

```
$ git submodule update --init
$ ./setup.sh
```

## Build Docker Image For Orange Pi R1+

```
$ bitbake orangepi-docker-image
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
