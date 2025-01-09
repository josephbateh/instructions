# HexOS Installation Instructions

Source: [link](https://hub.hexos.com/topic/4-hexos-early-access-program-read-me-first/).

## Disclaimer

Beta Products, Software, and any related Services are still in development, and therefore, you are advised to safeguard important data, to use caution, and not to rely in any way on the correct functioning or performance of the products, software, or any related services. Beta Products and Services are provided to you “AS IS”, without any warranty whatsoever.

## Expectations

During your participation in the beta, we expect you to do the obvious:  use and test the software.  But we also expect you to communicate with us when things don’t go right or if you’re having trouble.  Please post feedback and let us know about your experiences, good and bad.  That being said, please remember that this is beta software and early access.  HexOS has a long and healthy roadmap ahead.

## Quickstart Guide

For those that just want to get started, here's the TLDR:

Download the ISO [here](https://downloads.hexos.com/TrueNAS-SCALE-24.10.0-HexOS.iso).
Use a tool such as Balena Etcher or Rufus to image a USB flash device with the ISO. (Rufus has been problematic; stick with Balena Etcher)
Boot your server from the flash device and install the OS to preferably an SSD.
When given the option, opt to create the admin password in the installer (do not select the option to "Configure using WebUI").
Remove the flash device and reboot your server when the install is complete.
From another device (mobile, tablet, desktop) that is on the same LAN as your server, login to [deck](https://deck.hexos.com) using your HexOS credentials.
Follow the instructions to complete your server configuration.
Hardware Requirements

### Booting

HexOS is designed to support a wide variety of x86 hardware (Intel or AMD).  The minimum requirements are a 2-core 64-bit CPU, 8GB of memory, and a 16GB or larger SSD boot device.  However, depending on your needs for performance and applications, more resources may be required.

### Storage Pools

Pools are made up of storage devices based on size and type (HDDs vs. SSDs).
Storage devices in each pool need to be roughly the same size*.
The OS boot device cannot be a part of a pool.
Expandable pools require a minimum of 3 devices and can be grown one device at a time.
Non-expandable pools can be created with 2 devices.
Initial pool width should not exceed 8 devices.
Maximum expanded pool width should not exceed 12 devices.
At least one storage pool must be created to use HexOS.
*In the event of slight variations (e.g. 240GB and 256GB), devices can be grouped, but total capacity for the pool will sacrifice the larger device’s excess storage.

### Build Recommendations

HexOS has been designed so that a relatively modern PC can be easily transformed into a very viable home server.  This means using standard HDDs/SSDs and using onboard controllers for storage/networking.  However, since we’re based on TrueNAS, our hardware support is actually rather vast.  For more detailed hardware recommendations for advanced builds, please refer to the TrueNAS SCALE Hardware Guide.

### Installing in a VM

As HexOS is based on TrueNAS SCALE, it can be installed as a virtual machine as well.  While the process should be fairly self-explanatory, please see the TrueNAS SCALE documentation for additional instructions on VM installation.

### Setup and Configuration

Once the OS has been installed and rebooted, you will use a web browser on the same network as your server to register your system and complete the setup process.  This can be a PC, tablet, or mobile device.  Using a capable browser, login to [deck](https://deck.hexos.com).
