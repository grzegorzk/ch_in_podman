#!/bin/bash

set -e

cp -p /root/.Xauthority /home/ch/.Xauthority
chown ch:ch /home/ch/.Xauthority

cp -r -p /root/.config /home/ch/.config
chown -R ch:ch /home/ch/.Xauthority

# Read https://developers.google.com/web/updates/2017/04/headless-chrome - 'How do I create a Docker container that runs Headless Chrome?'
su ch --command "chromium --no-sandbox"
