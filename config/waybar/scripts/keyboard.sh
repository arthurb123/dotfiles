#!/bin/bash

current_im=$(fcitx5-remote)

if [ "$current_im" == "1" ]; then
    echo " ENG"
elif [ "$current_im" == "2" ]; then
    echo " JP"
else
    echo " Unknown"
fi