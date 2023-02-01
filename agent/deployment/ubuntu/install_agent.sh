#!/bin/bash

function deps {
    echo "Installing dependencies ..."

    apt-get update
    apt-get upgrade -y

    echo "Installing dependencies done!"
}

function mandrill {
    echo "Installing mandrill ..."

    mkdir -p /etc/mandrill
    cd /etc/mandrill
    LATEST_VERSION=$(curl --silent "https://api.github.com/repos/clivern/mandrill/releases/latest" | jq '.tag_name' | sed -E 's/.*"([^"]+)".*/\1/' | tr -d v)
    curl -sL https://github.com/clivern/mandrill/releases/download/v{$LATEST_VERSION}/mandrill_Linux_x86_64.tar.gz | tar xz

    echo "[Unit]
Description=Mandrill
Documentation=https://github.com/Clivern/Mandrill

[Service]
ExecStart=/etc/mandrill/mandrill agent -c /etc/mandrill/config.prod.yml
Restart=on-failure
RestartSec=2

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/mandrill_agent.service

    systemctl daemon-reload
    systemctl enable mandrill_agent.service
    systemctl start mandrill_agent.service

    echo "Mandrill installation done!"
}

deps
mandrill
