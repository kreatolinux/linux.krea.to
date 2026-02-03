---
title: "About"
draft: false 
---

**"Simplicity is the ultimate sophistication."**
    — Leonardo da Vinci

Kreato Linux is an independent Linux(R) distribution focused on modularity, simplicity and code readability. It was founded in 2021 for a simple need — returning modularity to the Linux landscape. Ever since then, it has turned into a fully independent ecosystem that has its own package manager, init system, build system, and more! It has many features that no other distribution has, which you can read below. 

Kreato Linux is in major development and things may change at any time, though we guarantee backwards compatibility or, at minimum, migration tools. Kreato Linux entered the beta stage in 2024. Kreato Linux is currently only rolling-release for ease of maintenance, although stable releases are planned in the future.

# Features

## Modular core
Kreato Linux's modular building tools allow you to mix-and-match components and create your own unique setup.

Unlike other distributions, Kreato Linux does not have a `base` package. You create your own base, with the choices provided by the Kreastrap tool, that allows you to build the system.

Our goal is to provide the most modular Linux system to exist. Most tools of Kreato Linux are built with portability in mind for this very reason.

## Jumpstart
Jumpstart is Kreato Linux's default init system, written in Nim. It allows as much modularity as possible to the user, while being minimal and easy-to-use. It uses Kongue scripts named decfiles (declaration files) for declaring units which allows much more flexibility than INI based units do on the likes of systemd, while being much safer and easier than things like OpenRC units.

Jumpstart is inspired from init systems such as systemd and rc.

Nothing is stopping you from using other init systems, such as systemd and OpenRC.

## Source/Binary hybrid package manager
Kreato Linux uses kpkg, a package manager written in Nim that gives you the choice of building or installing binaries with ease. This way you can choose what's best for your usecase. Kpkg supports advanced features such as a fully-functional REPL, a sophisticated dependency handler and a proper sandbox to build packages in. 

Kpkg is fast, and simple for what it does. It supports Kongue scripts named Runfiles that allow you to easily write packages, similar to other script-based formats. You can learn more about it from the kpkg_run(5) and the kongue(5) manpages.

## Kongue
Kongue is Kreato Linux's own scripting language. It is the base of many Kreato Linux projects, including but not limited to kpkg and jumpstart. Kongue is simple, but also very functional. It is inspired mainly by YAML, sh and HCL. You can learn more about it from the kongue(5) manpage.

## Kreastrap
Kreato Linux rootfs is built using Kreastrap, our modular rootfs builder that uses kpkg under the hood to achieve modular, speedy rootfs building. Kreastrap is written in Nim just like other tools.

## Good documentation
Kreato Linux uses manpages for the majority of its documentation. A documentation webpage is also available. Manpages are constantly updated and the code has been written in a way to be understandable.

Documentation is available [here](./docs).

## Independent
Kreato Linux is fully independent and tries its best to have no opinionated changes. The tools are also made as efficient as possible.

Tools such as [chkupd](https://github.com/kreatolinux/src#chkupd) allow Kreato Linux to be easy enough to maintainable by a single person.

# Contribute
Look at [the documentation](./docs) to understand how Kreato Linux works! You can also donate to me [on Github Sponsors](https://github.com/sponsors/kreatoo) to support the project financially. You can also join our [Discord](https://discord.gg/5vTYnkepX6) server where you can get quick updates about the project.

# Sponsors
We are grateful for the support received by the following organizations:

[1Password](https://1password.com)
