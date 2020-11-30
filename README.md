## Install and configure ipxe on Linux for diskless booting

---

We are going to install and configure a pxe-server in Linux. This can be used to boot computers over the network and install software.

### Tested on:

- [Ubuntu Server 20.04 64Bit](http://se.releases.ubuntu.com/20.04/ubuntu-20.04.1-live-server-amd64.iso)

|          |                               |
| -------- | ----------------------------- |
| Webpage: | http://www.leemann.se/fredrik |
| Github:  | https://github.com/freddan88  |
| video:   |                               |

### 1. Download and install dependencies and recommended software

```bash
$ sudo apt install isc-dhcp-server tftpd-hpa net-tools git nano zsh neofetch gcc binutils make \
perl unzip liblzma-dev liblzma5 mtools genisoimage syslinux apache2 build-essential liblzma-dev -y
```

### 2. Download iPXE and compile from source

> cd /tmp && git clone git://git.ipxe.org/ipxe.git && cd ipxe/src

Edit: config/general.h and config/console.h to include console commands in compiled binaries

- config/general.h

  - nano config/general.h
  - Uncomment #define IMAGE_PNG and #define CONSOLE_CMD
  - From: // #define CONSOLE_CMD to: #define CONSOLE_CMD

- config/console.h

  - nano config/console.h
  - Uncomment #define CONSOLE_FRAMEBUFFER
  - From: // #define CONSOLE_FRAMEBUFFER to: #define CONSOLE_FRAMEBUFFER

  ```bash
  $ cd ipxe/src && make all
  $ cd ipxe/src && make bin-x86_64-efi/ipxe.efi
  ```

### 3. Copy files to tftp and html-root

```bash
$ sudo cp bin/ipxe.pxe /srv/tftp
$ sudo cp bin/undionly.kpxe /srv/tftp
$ sudo cp bin-x86_64-efi/ipxe.efi /srv/tftp
```

```bash
$ cd /tmp
$ wget http://git.ipxe.org/releases/wimboot/wimboot-latest.zip
$ wget http://boot.ipxe.org/ipxe.png
$ unzip wimboot-latest.zip
$ sudo cp ipxe.png /var/www/html
$ sudo cp wimboot*/wimboot /var/www/html
$ sudo cp /usr/lib/syslinux/memdisk /var/www/html
```
