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
sudo apt install isc-dhcp-server tftpd-hpa net-tools git nano zsh neofetch gcc binutils make perl unzip \
liblzma-dev liblzma5 mtools genisoimage syslinux apache2 build-essential liblzma-dev -y
```
