
#!/bin/bash
set -eux

apt-get update -y
apt-get install -y python3

cat > /opt/app.py <<'EOF'
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        message = b"Application Tier is Running"

        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(message)))
        self.end_headers()
        self.wfile.write(message)

server = HTTPServer(("0.0.0.0", 8080), Handler)
server.serve_forever()
EOF

cat > /etc/systemd/system/three-tier-app.service <<'EOF'
[Unit]
Description=Three Tier Python Application
After=network.target

[Service]
ExecStart=/usr/bin/python3 /opt/app.py
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable three-tier-app
systemctl start three-tier-app
