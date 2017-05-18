#!/bin/bash

set -xeo pipefail

# TODO(pquerna): quantify this
# Zero out the rest of the free space using dd, then delete the written file.
# dd if=/dev/zero of=/EMPTY bs=1M
# rm -f /EMPTY

sudo apt-get -y clean
sudo apt-get -y autoclean

sudo rm -f /etc/sftd/disable-autostart

TMPFILE=`mktemp`
cat >${TMPFILE} <<EOL
#!/bin/bash

set -xeo pipefail

sleep 1

userdel --remove --force packer-image-builder

...
EOL

sudo chmod +x ${TMPFILE}

sudo systemd-run --uid=0 --gid=0 "${TMPFILE}"

sudo rm -rf /home/admin/.ssh/authorized_keys
sudo rm -rf /home/admin/.ansible
sudo rm -rf /root/.ssh/authorized_keys
sudo rm -rf /root/.aptitude
sudo rm -rf /etc/ssh/*key*
sudo find /var/log -type f | sudo xargs tee

exit 0
