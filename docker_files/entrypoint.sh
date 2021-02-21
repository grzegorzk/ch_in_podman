#!/bin/bash

set -e

# Read https://developers.google.com/web/updates/2017/04/headless-chrome - 'How do I create a Docker container that runs Headless Chrome?'
chromium --no-sandbox
