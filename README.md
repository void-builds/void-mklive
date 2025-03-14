
# The Void Linux live image/rootfs generator and installer

## Overview

This repository contains several utilities:

* [*mklive.sh*](#mklivesh) - The Void Linux live image generator for x86
* [*mkiso.sh*](#mkisosh) - Wrapper script to generate bootable and installable live
  images for i686, x86_64, and aarch64.
* [*mkrootfs.sh*](#mkrootfssh) - The Void Linux rootfs generator for all platforms
* [*mkplatformfs.sh*](#mkplatformfssh) - The Void Linux filesystem tool to produce
  a rootfs for a particular platform
* [*mkimage.sh*](#mkimagesh) - The Void Linux image generator for ARM platforms
* [*mknet.sh*](#mknetsh) - Script to generate netboot tarballs for Void
* *installer.sh* - The Void Linux el-cheapo installer for x86
* *release.sh* - interacts with GitHub CI to generate and sign images for releases

### Workflow

#### Generating x86 live ISOs

To generate a live ISO like the officially-published ones, use
[*mkiso.sh*](#mkisosh). To generate a more basic live ISO
(which does not include things like `void-installer`), use [*mklive.sh*](#mklivesh).

#### Generating ROOTFS tarballs

ROOTFS tarballs contain a basic Void Linux root filesystem without a kernel.
These can be useful for doing a [chroot install](https://docs.voidlinux.org/installation/guides/chroot.html)
or for [chroots and containers](https://docs.voidlinux.org/config/containers-and-vms/chroot.html).

Use [*mkrootfs.sh*](#mkrootfssh) to generate a Void Linux ROOTFS.

#### Generating platform-specific tarballs

Platform-specific ROOTFS tarballs, or PLATFORMFS tarballs, contain a basic Void
Linux root filesystem including a kernel. These are commonly used for bootstrapping
ARM systems or other environments that require platform-specific kernels, like
Raspberry Pis.

First create a ROOTFS for the desired architecture, then use
[*mkplatformfs.sh*](#mkplatformfssh) to generate a Void Linux PLATFORMFS.

#### Generating ARM images

Platform-specific filesystem images contain a basic filesystem layout (`/` and
`/boot` partitions), ready to be copied to the target drive with `dd`. These are
not "live" images like those available on x86 platforms, and do not need
installation like live ISOs.

To generate these images, first create a PLATFORMFS for the desired platform,
then use [*mkimage.sh*](#mkimagesh) to generate the image.

## Build Dependencies
 * make

=======
## Dependencies
 * Compression type for the initramfs image
   * liblz4 (for lz4, xz) (default)
 * xbps>=0.45
 * qemu-user-static binaries (for mkrootfs)

Note that void-mklive is not guaranteed to work on distributions other than Void
Linux, or in containers.

See the usage output:

    $ ./mklive.sh -h
    $ ./mkrootfs.sh -h
    $ ./mkimage.sh -h

## Building an image

**make sure you have your gpg2 key imported and export a .asc file from your key**

    ./kde-x86.sh

This will use the mklive.sh script to create a build with the packages listed in kde-x86.packages file. 

## Examples
=======
### Examples

Build a native live image keyboard set to 'fr':

    # ./mklive.sh -k fr

Build an i686 (on x86\_64) live image with some additional packages:

    # ./mklive.sh -a i686 -p 'vim rtorrent'

Build an x86\_64 musl live image with packages stored in a local repository:

    # ./mklive.sh -a x86_64-musl -r /path/to/host/binpkgs

See the usage output for more information :-)
=======
* Compression type for the initramfs image (by default: liblz4 for lz4, xz)
* xbps>=0.45
* qemu-user-static binaries (for mkrootfs)
* bash
>>>>>>> 4c53797b27a6f10154cc6588243539a68a167e06

## Kernel Command-line Parameters

`void-mklive`-based live images support several kernel command-line arguments
that can change the behavior of the live system:

- `live.autologin` will skip the initial login screen on `tty1`.
- `live.user` will change the username of the non-root user from the default
  `anon`. The password remains `voidlinux`.
- `live.shell` sets the default shell for the non-root user in the live environment.
- `live.accessibility` enables accessibility features like the console screenreader
  `espeakup` in the live environment.
- `console` can be set to `ttyS0`, `hvc0`, or `hvsi0` to enable `agetty` on that
  serial console.
- `locale.LANG` will set the `LANG` environment variable. Defaults to `en_US.UTF-8`.
- `vconsole.keymap` will set the console keymap. Defaults to `us`.

### Examples:

- `live.autologin live.user=foo live.shell=/bin/bash` would create the user `foo`
  with the default shell `/bin/bash` on boot, and log them in automatically on `tty1`
- `live.shell=/bin/bash` would set the default shell for the `anon` user to `/bin/bash`
- `console=ttyS0 vconsole.keymap=cf` would enable `ttyS0` and set the keymap in
  the console to `cf`
- `locale.LANG=fr_CA.UTF-8` would set the live system's language to `fr_CA.UTF-8`

## Usage

### mkiso.sh

```
Usage: mkiso.sh [options ...] [-- mklive options ...]

Wrapper script around mklive.sh for several standard flavors of live images.
Adds void-installer and other helpful utilities to the generated images.

OPTIONS
 -a <arch>     Set architecture (or platform) in the image
 -b <variant>  One of base, enlightenment, xfce, mate, cinnamon, gnome, kde,
               lxde, lxqt, or xfce-wayland (default: base). May be specified multiple times
               to build multiple variants
 -d <date>     Override the datestamp on the generated image (YYYYMMDD format)
 -t <arch-date-variant>
               Equivalent to setting -a, -b, and -d
 -r <repo>     Use this XBPS repository. May be specified multiple times
 -h            Show this help and exit
 -V            Show version and exit

Other options can be passed directly to mklive.sh by specifying them after the --.
See mklive.sh -h for more details.
```

### mklive.sh

```
Usage: mklive.sh [options]

Generates a basic live ISO image of Void Linux. This ISO image can be written
to a CD/DVD-ROM or any USB stick.

To generate a more complete live ISO image, use mkiso.sh.

OPTIONS
 -a <arch>          Set XBPS_ARCH in the ISO image
 -b <system-pkg>    Set an alternative base package (default: base-system)
 -r <repo>          Use this XBPS repository. May be specified multiple times
 -c <cachedir>      Use this XBPS cache directory (default: ./xbps-cachedir-<arch>)
 -k <keymap>        Default keymap to use (default: us)
 -l <locale>        Default locale to use (default: en_US.UTF-8)
 -i <lz4|gzip|bzip2|xz>
                    Compression type for the initramfs image (default: xz)
 -s <gzip|lzo|xz>   Compression type for the squashfs image (default: xz)
 -o <file>          Output file name for the ISO image (default: automatic)
 -p "<pkg> ..."     Install additional packages in the ISO image
 -g "<pkg> ..."     Ignore packages when building the ISO image
 -I <includedir>    Include directory structure under given path in the ROOTFS
 -S "<service> ..." Enable services in the ISO image
 -e <shell>         Default shell of the root user (must be absolute path).
                    Set the live.shell kernel argument to change the default shell of anon.
 -C "<arg> ..."     Add additional kernel command line arguments
 -P "<platform> ..."
                    Platforms to enable for aarch64 EFI ISO images (available: pinebookpro, x13s)
 -T <title>         Modify the bootloader title (default: Void Linux)
 -v linux<version>  Install a custom Linux version on ISO image (default: linux metapackage).
                    Also accepts linux metapackages (linux-mainline, linux-lts).
 -K                 Do not remove builddir
 -h                 Show this help and exit
 -V                 Show version and exit
```

### mkrootfs.sh

```
Usage: mkrootfs.sh [options] <arch>

Generate a Void Linux ROOTFS tarball for the specified architecture.

Supported architectures:
 i686, i686-musl, x86_64, x86_64-musl,
 armv5tel, armv5tel-musl, armv6l, armv6l-musl, armv7l, armv7l-musl
 aarch64, aarch64-musl,
 mipsel, mipsel-musl,
 ppc, ppc-musl, ppc64le, ppc64le-musl, ppc64, ppc64-musl
 riscv64, riscv64-musl

OPTIONS
 -b <system-pkg>  Set an alternative base-system package (default: base-container-full)
 -c <cachedir>    Set XBPS cache directory (default: ./xbps-cachedir-<arch>)
 -C <file>        Full path to the XBPS configuration file
 -r <repo>        Use this XBPS repository. May be specified multiple times
 -o <file>        Filename to write the ROOTFS to (default: automatic)
 -x <num>         Number of threads to use for image compression (default: dynamic)
 -h               Show this help and exit
 -V               Show version and exit
```

### mkplatformfs.sh

```
Usage: mkplatformfs.sh [options] <platform> <rootfs-tarball>

Generates a platform-specific ROOTFS tarball from a generic Void Linux ROOTFS
generated by mkrootfs.sh.

Supported platforms: i686, x86_64, GCP,
                     rpi-armv6l, rpi-armv7l, rpi-aarch64,
                     pinebookpro, pinephone, rock64, rockpro64, asahi

OPTIONS
 -b <system-pkg>  Set an alternative base-system package (default: base-system)
 -c <cachedir>    Set the XBPS cache directory (default: ./xbps-cachedir-<arch>)
 -C <file>        Full path to the XBPS configuration file
 -k <cmd>         Call '<cmd> <ROOTFSPATH>' after building the ROOTFS
 -n               Do not compress the image, instead print out the ROOTFS directory
 -o <file>        Filename to write the PLATFORMFS archive to (default: automatic)
 -p "<pkg> ..."   Additional packages to install into the ROOTFS
 -r <repo>        Use this XBPS repository. May be specified multiple times
 -x <num>         Number of threads to use for image compression (default: dynamic)
 -h               Show this help and exit
 -V               Show version and exit
```

### mkimage.sh

```
Usage: mkimage.sh [options] <platformfs-tarball>

Generates a filesystem image suitable for writing with dd from a PLATFORMFS
tarball generated by mkplatformfs.sh. The filesystem layout is configurable,
but customization of the installed system should be done when generating the
PLATFORMFS. The resulting image will have 2 partitions, /boot and /.

OPTIONS
 -b <fstype>    /boot filesystem type (default: vfat)
 -B <bsize>     /boot filesystem size (default: 256MiB)
 -r <fstype>    / filesystem type (default: ext4)
 -s <totalsize> Total image size (default: 900MiB)
 -o <output>    Image filename (default: guessed automatically)
 -x <num>       Number of threads to use for image compression (default: dynamic)
 -h             Show this help and exit
 -V             Show version and exit

Accepted size suffixes: KiB, MiB, GiB, TiB, EiB.

The <platformfs-tarball> argument expects a tarball generated by mkplatformfs.sh.
The platform is guessed automatically by its name.
```

### mknet.sh

```
Usage: mknet.sh [options] <rootfs-tarball>

Generates a network-bootable tarball from a Void Linux ROOTFS generated by mkrootfs.

OPTIONS
 -r <repo>          Use this XBPS repository. May be specified multiple times
 -c <cachedir>      Use this XBPS cache directory (default: )
 -i <lz4|gzip|bzip2|xz>
                    Compression type for the initramfs image (default: xz)
 -o <file>          Output file name for the netboot tarball (default: automatic)
 -K linux<version>  Install a custom Linux version on ISO image (default: linux metapackage)
 -k <keymap>        Default keymap to use (default: us)
 -l <locale>        Default locale to use (default: en_US.UTF-8)
 -C "<arg> ..."     Add additional kernel command line arguments
 -T <title>         Modify the bootloader title (default: Void Linux)
 -S <image>         Set a custom splash image for the bootloader (default: data/splash.png)
 -h                 Show this help and exit
 -V                 Show version and exit
```

