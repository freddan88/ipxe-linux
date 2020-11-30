## Install and configure ipxe on Linux for diskless booting and remote installations

---

In this tutorial We are going to install and configure a pxe-server.

### Tested on:

- [Ubuntu Server 20.04 64Bit](http://se.releases.ubuntu.com/20.04/ubuntu-20.04.1-live-server-amd64.iso)

|          |                               |
| -------- | ----------------------------- |
| Webpage: | http://www.leemann.se/fredrik |
| Github:  | https://github.com/freddan88  |
| video:   |                               |

### 1. Download and install dependencies and recommended software

```bash
sudo apt install isc-dhcp-server tftpd-hpa net-tools git nano zsh neofetch gcc binutils make perl liblzma-dev liblzma5 mtools genisoimage syslinux apache2 build-essential liblzma-dev unzip -y
```
