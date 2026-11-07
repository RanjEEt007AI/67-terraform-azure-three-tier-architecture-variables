
#!/bin/bash
set -eux

apt-get update -y

apt-get install -y postgresql

systemctl enable postgresql
systemctl start postgresql

systemctl status postgresql
