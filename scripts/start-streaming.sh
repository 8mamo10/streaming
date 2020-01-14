#!/bin/bash
NUM=`ps aux | grep ffmpeg | grep -v grep | wc -l`
if [ $NUM -gt 0 ]; then
        echo "Already running."
        exit
fi

sudo ffmpeg \
        -f v4l2 -thread_queue_size 8192 \
        -input_format yuyv422 -video_size 640x480 \
        -framerate 30 -i /dev/video0 -c:v h264_omx \
        -b:v 768k -bufsize 768k -vsync 1 -g 16 \
        -c:a aac -b:a 128k -ar 44100 -af "volume=30dB" \
        -f flv rtmp://localhost/live/stream > /dev/null 2>&1 </dev/null &
