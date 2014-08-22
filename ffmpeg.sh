#!/bin/sh

ffmpeg -i a.mov -c copy a.mp4

ffmpeg -i a.rmvb -f mp3 -vn a.mp3
