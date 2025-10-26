---
title: "Installation"
draft: false
---

## Introduction 

Welcome to Kreato Linux installation guide! 

### Note

It is assumed that you have a partition layout already setup.

It is also assumed that you are using a UEFI system.

Kreato Linux doesn't have a live ISO image. It is assumed that you would start the installation from another Linux installation.

If you do not have a working Linux install, we recommend [Arch Linux LiveISO](https://archlinux.org/download/) for installation.

### Here be dragons! 

Keep in mind that Kreato Linux is in Beta stage and *may* have issues.

If you want a more polished experience, please wait until it is announced to be stable.

By continuing to install and use Kreato Linux, you agree that you have a good understanding of Linux systems.

Any basic issues/anything not related to Kreato Linux will be closed without warning.


## Get rootfs tarball
First step should be to get the rootfs tarball. Kreato Linux installs through a rootfs (Like Gentoo). You can get the latest nightly through [The downloads page](https://linux.krea.to/downloads/)

### Choosing the right tarball
Kreato Linux is a modular distribution. There are four build types currently available.

* nocc-rootfs
* builder-rootfs
* builder-gnu-rootfs
* and builder-systemd-rootfs.

nocc-rootfs is completely built by GitHub Actions and as the name implies, doesnt have any compilers by default. You can use binaries to install any compilers, or dont build at all and use the system with just binaries.

builder-rootfs is also built by GitHub actions and comes with gcc.

builder-gnu-rootfs is just builder-rootfs with GNU coreutils, this is for building problematic packages with Busybox such as systemd.

builder-systemd-rootfs is builder-gnu-rootfs but uses systemd instead of Jumpstart.

### Extracting
Mount the partition you are gonna install it to `/mnt`.\
Once downloaded, extract the zip file and you will get a tarball.\
Extract the tarball using the command `tar --same-owner -xvf kreato-linux-*.tar.gz -C /mnt`\
Once extracted, we can move on to chrooting.

## Chrooting
Before chrooting, mount your EFI partition to `/boot`.
Run these commands to chroot.

```sh
mount -o bind /dev /mnt/dev
mount -t proc none /mnt/proc
mount -o bind /sys /mnt/sys
mount -o bind /tmp /mnt/tmp
chroot /mnt /bin/bash
. /etc/profile
```

And you should be in! 

## Installing base system packages

### Binary vs. Source
Kreato Linux offers 2 choices for installation.

* Source based (compiling software),
* And binary based (installing from binary repository).

Both choices have their own advantages.

#### Advantages and disadvantages of building packages
* Updates come faster.
* Has more customizability and optimization options.
* Building is slower than downloading a binary tarball.

#### Advantages and disadvantages of binary packages
* Updates are available with a lag.
* Has less customizability.
* Doesn't require building packages, making it more suitable to older/less powerful systems.
* Is not currently stable, packages may not even exist on the mirror.

This installation guide will assume that you are gonna install binary packages (`kpkg install packagename`). If you want to build packages, please change `kpkg install` to `kpkg build` so it builds the packages instead of installing the binary.

### Stable repositories vs master
Kreato Linux has 2 branches in official repositories named `master` and `stable`.</br>
As the name implies, `stable` is the stable branch. `master` is the unstable branch.

#### Advantages and disadvantages of stable
* Packages that are added in stable are *usually* well-tested and ready for production.
* Packages may be out of date compared to the master branch.
* Most recent additions wont be there, atleast until they are considered well-tested.
* Is the default repository.

#### Advantages and disadvantages of master.
* It is cutting edge, it will get the updates first.
* Packages may be for a more recent, unreleased version of `kpkg`.
* Most recent additions and improvements will be there.
* Is not the default unless you build `kpkg` manually.

Kreato Linux is mostly focused on the master branch for now, but we try to keep stable recent enough.\
You can switch to the branches by editing `repoLinks` on `/etc/kpkg/kpkg.conf`. If the file doesn't exist, run `kpkg` since it'll generate the files for you.

Now we can continue with installing base system packages.

### Installing the init system
Kreato Linux includes multiple init systems. systemd, OpenRC and Jumpstart exist as a option. Jumpstart is the default and recommended option.

* If you want systemd; you can install `systemd`: `kpkg install systemd`. Systemd also comes by default in builder-systemd-rootfs.
* If you want OpenRC: you can install `openrc`: `kpkg install openrc`
* If you want Jumpstart, it is installed by default on every rootfs except `builder-systemd-rootfs`

### Installing networking tools
`dhcpcd` is recommended. run `kpkg install dhcpcd` to install `dhcpcd`.\
You should install `wpa_supplicant` aswell if you need Wi-Fi connectivity. run `kpkg install wpa_supplicant` to install it.


### Installing the kernel
You can either build your own kernel or use Kreato Linux's kernel, that uses Gentoo's kernel configuration.\
It is recommended to build your own kernel, since it will be much more minimal and will compile faster (if you are building the package).\
You can run `kpkg install linux` to install the prebuilt kernel.\
As for building your own kernel, you can check out [This video](https://www.youtube.com/watch?v=NVWVHiLx1sU).

### Building the initramfs
You can use either `dracut`, which doesn't work on Busybox systems at the moment, or `booster`.\
Both are valid options and both are tested.\
Keep in mind that `dracut` has been only tested on systems using systemd, your mileage may vary. 

### Installing the bootloader
Kreato Linux offers multiple bootloaders.\
You can use Limine or Grub.

Grub is the most tested option.

You can install Grub by running `kpkg install grub`.\
You can then install it to `/boot` like so; `grub-install --target=x86_64-efi --efi-directory=/boot`
Then generate the config; `grub-mkconfig -o /boot/grub/grub.cfg`


As for Limine, you can install it by running `kpkg install limine`.\
Configuration is already explained greatly on [Arch Wiki](https://wiki.archlinux.org/title/Limine), so i wont repeat it here.

## Change the root password
You should change the root password by running this command;
`passwd root`
If you want to do so, you can also add additional users with `useradd`.

Now you should be able to boot Kreato Linux by itself.

## Setting up the locale
You can set up the locale by running these commands. Change `LOCALE=en_US` with your language (Example; `LOCALE=de_DE` for German)

```sh
LOCALE=en_US
mkdir -p /usr/lib/locale
localedef -i $LOCALE -c -f UTF-8 $LOCALE
echo "export LANG=$LOCALE.UTF-8" >> /etc/profile
```

## Install Flatpak
As the repositories are very tiny, you may need Flatpak to get packages.\
Install Flatpak; `kpkg install flatpak`\
Then you can get apps from Flathub by running; `flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo`

## Installing a Window Manager
Kreato Linux only offers `sway` for now.
You can install sway by running `kpkg install sway`.\
More Wayland window managers are coming soon.\
You can also install foot, a terminal by running `kpkg install foot`.

## Installing Desktop Environments
Kreato Linux only offers GNOME for now in terms of desktop environments.

# GNOME
Install it by running `kpkg install gnome`.</br>
You can then enable and start GDM as a display manager by running `jumpctl enable gdm --now` or `systemctl enable gdm --now`.</br>
You can also start GNOME manually by running `XDG_SESSION_TYPE=wayland dbus-run-session gnome-session`.


# What's Next
You can tinker with your setup, install additional software, package something, etc.

If you want to contribute to Kreato Linux, you can look at the [Contribution Guide](../contributing).
