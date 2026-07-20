#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Send keys
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🔑
# @raycast.argument1 { "type": "text", "placeholder": "host" }

# Documentation:
# @raycast.description Send auth key to the given server
# @raycast.author Cole Eason
# @raycast.authorURL cole.dev

/Users/cole/.local/bin/saltfab -H "$1" -g bastion1.sjc authrock.sendKey
