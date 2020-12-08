## Install and configure ipxe on Linux for diskless booting

---

We are going to install and configure a pxe-server in Linux. This can be used to boot computers over the network and install software.

### Tested on:

- [Ubuntu Server 20.04 64Bit](http://se.releases.ubuntu.com/20.04/ubuntu-20.04.1-live-server-amd64.iso)

| My Links |                               |
| -------- | ----------------------------- |
| Webpage: | http://www.leemann.se/fredrik |
| Github:  | https://github.com/freddan88  |
| Video:   |                               |

### 1. Download and install dependencies and recommended software

```bash
sudo apt install isc-dhcp-server tftpd-hpa net-tools git nano zsh neofetch gcc binutils make \
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

#### Compile sources

> make all && make bin-x86_64-efi/ipxe.efi

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

### 4. Download new configuration and restart DHCP

```bash
$ cd /etc/dhcp
$ sudo mv dhcpd.conf dhcpd.conf.old
$ sudo wget https://raw.githubusercontent.com/freddan88/ipxe-linux/main/dhcpd.conf
```

### 5. Download iPXE-menu by stefan1 from forum.ipxe.org

```bash
$ mkdir -p /srv/tftp/menu && cd /srv/tftp/menu
$ sudo wget https://raw.githubusercontent.com/freddan88/ipxe-linux/main/ipxe_menu.txt
```

### 6. Download script to manage this server

```bash
$ cd /srv
$ sudo wget https://raw.githubusercontent.com/freddan88/ipxe-linux/main/ipxesrv.sh
$ sudo chown root:root ipxesrv.sh && sudo chmod 775 ipxesrv.sh
$ sudo ln -sf /srv/ipxesrv.sh /usr/local/sbin/ipxesrv
```

### 7. Edit permissions and restart services

- sudo ipxesrv perm
- sudo ipxesrv restart

### 8. Try to boot some clients over the network

Important configurations:

- /srv/tftp/ipxe_menu.txt
- /etc/default/tftpd-hpa
- /etc/dhcp/dhcpd.conf

Run script from anywhere:

| Arguments in script |                                              |
| ------------------- | -------------------------------------------- |
| ipxesrv start       | Start the services for ipxe pxe-server       |
| ipxesrv stop        | Stop the services for ipxe pxe-server        |
| ipxesrv restart     | Restart the services for ipxe pxe-server     |
| ipxesrv status      | Check status for services in ipxe pxe-server |
| ipxesrv perm        | Change permissions on folders in pxe-server  |
| ipxesrv enable      | Enable autostart and start ipxe pxe-server   |
| ipxesrv disable     | Disable autostart and stop ipxe pxe-server   |

## Optional samba configuration

Install samba:

> sudo apt install samba

Append configuration to smb.conf:

> sudo nano /etc/samba/smb.conf

```
[tftp]
force user = tftp
force group = nogroup
comment = ipxe-tftp
valid users = tftp
path = /srv/tftp
read only = yes
printable = no
writable = yes
guest ok = no
public = no
```

### Restart services and finalize configuration

Add password for samba to tftp

> smbpasswd -a tftp

Restart and set permissions

```bash
$ sudo service smbd restart
$ sudo service nmbd restart
$ sudo ipxesrv perm
```

### Try to mount the share from another computer eg Windows

### Resources

- https://askubuntu.com/questions/851433/kernel-doesnt-support-pic-mode-for-compiling
- https://backreference.org/2013/11/24/pxe-server-with-dnsmasq-apache-and-ipxe
- https://www.youtube.com/watch?v=hvRoPsgUHI4
- https://www.youtube.com/watch?v=dCod6zG8ijw
- https://forum.ipxe.org/showthread.php?tid=6065
- https://ipxe.org/appnote/buildtargets
- https://ipxe.org/howto/chainloading
- https://ipxe.org/buildcfg/image_png
- https://ipxe.org/howto/dhcpd
- https://ipxe.org/cmd/console
- https://ipxe.org/wimboot
- https://ipxe.org/buildcfg
- https://networkboot.org
- https://github.com/ipxe
