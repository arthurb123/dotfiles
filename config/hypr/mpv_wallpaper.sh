#!/usr/bin/env bash
mpvpaper '*' -o "--hwdec=vaapi --vd-lavc-skiploopfilter=all --profile=fast --loop --no-audio --framedrop=decoder+vo --speed=.775" ~/Videos/wallpaper.mp4
