
#!/bin/bash
set -eux

apt-get update -y
apt-get install -y nginx

cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Azure Three Tier Architecture</title>
</head>
<body>
    <h1>Welcome to Web Tier</h1>
    <h2>Azure Three Tier Architecture</h2>
    <p>Deployed using Terraform</p>
    <p>Managed by Ranjeet Kumar</p>
</body>
</html>
EOF

systemctl enable nginx
systemctl restart nginx
