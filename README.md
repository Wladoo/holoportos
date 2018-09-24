# holoport
The Holoport Project

## FAQ
- [FAQ](#sec-1)
  - [What is HoloPortOS?](#sec-1-1)
  - [Where can I find updates about Holoports and HoloportOS?](#sec-1-2)
  - [I want a holoport, can I still order one?](#sec-1-3)
  - [What if I can't afford a HoloPort?](#sec-1-4)
  - [Installation of Holoport OS on X86_64 Holoport hardware](#sec-1-5)

# FAQ<a id="sec-1"></a>

## What is HoloPortOS?<a id="sec-1-1"></a>

HoloportOS is an operating system that supports running [holochain](https://holochain.org/) applications, designed from the ground up to be consistent, verifiable, and auditable. That's because the Holo-Host team have chosen [NixOS](https://nixos.org/nix/), the purely functional operating system, as a basis to build on. You can already install the Alpha of holochain on any system with [nix, the purely functional package manager](https://nixos.org/nix/) installed. That's as easy as ~j

```bash
curl https://nixos.org/nix/install; nix-env -i holochain-go
```

## Where can I find updates about Holoports and HoloportOS?<a id="sec-1-2"></a>

You can follow along development of holoport in the work in [our fork of nixpkgs](https://github.com/holo-host/nixpkgs), but keep in mind that as of 19/07 we have lots of other repos and worktrees which are private, and we are working to take our first steps of bringing this part of the project into an organized Relevant mattermost channel would be [Holoport / Host Q&A](https://chat.holochain.org/appsup/channels/holoport-host-qa)

## I want a holoport, can I still order one?<a id="sec-1-3"></a>

Ask in the [Holoport Channel](https://chat.holochain.org/appsup/channels/holoport-host-qa) on public mattermost, and mention @gavinrogers

## What if I can't afford a HoloPort?<a id="sec-1-4"></a>

Great! It's good to have people around who want to run a holo host at home: we want to support the next revolution in the indieweb, homebrew computer tradition.

Currently we are targeting [initial batch](https://www.indiegogo.com/projects/holo-take-back-the-internet-shared-p2p-hosting-community#/) of HoloPorts, but we're engineering it (based upon NixOS) to be able to support DIY installations on dozens of platforms, from bare metal x86 and arm to [MIPS](https://www.linux-mips.org/wiki/Distributions#NixOS), [Linksys WRT (and simliar) routers](https://github.com/telent/nixwrt), and development is underway for [mobile devices, e.g. "Android" phones](https://github.com/samueldr/mobile-nixos/tree/feature/stage-2).

Because the HoloPort team is certainly designing with the goal of allowing just that: people to take the software and set it up on whatever they possibly can. At the moment we're focusing a lot of resources on supporting our paying customers, but there's no reason you can't order a box yourself. I personally beleive (but this is blowing smoke up my own arse) that it's going to be money well spent, and we're working to making the product something that people will remember like they remember the first iPhone (but with a less dodgy shareholder demo).

To that end, if you'd like to help out, feel free to check out the [Holo-Host github org](https://github.com/Holo-Host/) where we are starting to release some of the development of HoloHostOS which


## Installation of Holoport OS on X86_64 Holoport hardware<a id="sec-1-5"></a>

1. Run USB Live CD installer and use latest to install live cd version of holoport os, it should boot and login to root without password

2. use fdisk make 1 partition with the following combination `fdisk /dev/sda n p 1 <enter> <enter>` 

3. mkfs.ext4 /dev/sda1

4. mount /dev/sda1 /mnt (mount target file system on newly created partition

5. nixos-generate-config --root /mnt

6. edit target system on /mnt/etc/nixos/configuration.nix and uncomment `boot.loader.grub.device = "/dev/sda";`

7. Run `nixos-install`

8. reboot and the system should boot into the nixos-based holoportos