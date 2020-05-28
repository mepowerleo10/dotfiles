#!/bin/bash

i3-msg "workspace 6; append_layout .config/i3/workspace-6.json"
kunst
kitty --name ncmpcpp ncmpcpp
i3-msg 'assign [instance="Kunst"] $ws6'
i3-msg 'assign [instance="ncmpcpp"] $ws6'
