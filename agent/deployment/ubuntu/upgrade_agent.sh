#!/bin/bash

function mandrill {
    echo "Upgrade mandrill ..."

    cd /etc/mandrill
    mv config.prod.yml config.back.yml

    LATEST_VERSION=$(curl --silent "https://api.github.com/repos/Clivern/Mandrill/releases/latest" | jq '.tag_name' | sed -E 's/.*"([^"]+)".*/\1/' | tr -d v)

    curl -sL https://github.com/Clivern/Mandrill/releases/download/v{$LATEST_VERSION}/mandrill_Linux_x86_64.tar.gz | tar xz

    rm config.prod.yml
    mv config.back.yml config.prod.yml

    systemctl restart mandrill_agent

    echo "Mandrill upgrade done!"
}

mandrill
