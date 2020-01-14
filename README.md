# streaming

## Rasbian
```
$ uname -a
Linux raspberrypi 4.19.57+ #1244 Thu Jul 4 18:42:50 BST 2019 armv6l GNU/Linux
```

## nginx
```
$ sudo apt update
$ sudo apt install nginx
$ nginx -v
nginx version: nginx/1.14.2
$ systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
   Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2020-01-14 21:50:10 JST; 42s ago
     Docs: man:nginx(8)
 Main PID: 6557 (nginx)
   Memory: 3.3M
   CGroup: /system.slice/nginx.service
           ├─6557 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
           └─6558 nginx: worker process

Jan 14 21:50:10 raspberrypi systemd[1]: Starting A high performance web server and a reverse proxy server...
Jan 14 21:50:10 raspberrypi systemd[1]: Started A high performance web server and a reverse proxy server.
```

## video device
```
$ v4l2-ctl --list-device
bcm2835-codec (platform:bcm2835-codec):
        /dev/video10
        /dev/video11
        /dev/video12

mmal service 16.1 (platform:bcm2835-v4l2):
        /dev/video0
```

## ffmpeg
```
$ sudo apt install ffmpeg
$ ffmpeg --version
ffmpeg: symbol lookup error: /usr/lib/arm-linux-gnueabihf/libavcodec.so.58: undefined symbol: bcm_host_is_fkms_active
$ sudo apt upgrade # https://github.com/raspberrypi/firmware/issues/1319
$ ffmpeg -version
ffmpeg version 4.1.4-1+rpt6~deb10u1 Copyright (c) 2000-2019 the FFmpeg developers
built with gcc 8 (Raspbian 8.3.0-6+rpi1)
configuration: --prefix=/usr --extra-version='1+rpt6~deb10u1' --toolchain=hardened --incdir=/usr/include/arm-linux-gnueabihf --enable-gpl --disable-stripping --enable-avresample --disable-filter=resample --enable-avisynth --enable-gnutls --enable-ladspa --enable-libaom --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 --enable-libflite --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libgme --enable-libgsm --enable-libjack --enable-libmp3lame --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libopus --enable-libpulse --enable-librsvg --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libssh --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opengl --enable-sdl2 --enable-omx-rpi --enable-mmal --enable-neon --disable-vaapi --disable-vdpau --enable-rpi --enable-libdc1394 --enable-libdrm --enable-libiec61883 --enable-chromaprint --enable-frei0r --enable-libx264 --enable-shared --libdir=/usr/lib/arm-linux-gnueabihf --cpu=arm1176jzf-s --arch=arm
libavutil      56. 22.100 / 56. 22.100
libavcodec     58. 35.100 / 58. 35.100
libavformat    58. 20.100 / 58. 20.100
libavdevice    58.  5.100 / 58.  5.100
libavfilter     7. 40.101 /  7. 40.101
libavresample   4.  0.  0 /  4.  0.  0
libswscale      5.  3.100 /  5.  3.100
libswresample   3.  3.100 /  3.  3.100
libpostproc    55.  3.100 / 55.  3.100
```

## hls
```
$ sudo mkdir -p /var/www/html/live
$ cd /var/www/html/live/
$ sudo ln -s /dev/shm/ hls
```

## index.html
```
$ sudo vim /var/www/html/index.html

See https://github.com/video-dev/hls.js
```

## rtmp
```
$ sudo apt install libnginx-mod-rtmp
$ sudo vi /etc/nginx/conf.d/rtmp
$ sudo sh -c "echo \"include /etc/nginx/conf.d/rtmp;\" >> /etc/nginx/nginx.conf" 
```

## nginx setting
```
$ sudo vim /etc/nginx/conf.d/default.conf
$ sudo systemctl daemon-reload
$ sudo systemctl restart nginx
```

## scripts
```
$ vi scripts/start-streaming.sh
$ vi scripts/stop-streaming.sh
$ chmod +x scripts/st*.sh
```

Initially this error occurred. So I adjusted the video_size. (432x240 -> 640x480)
```
[video4linux2,v4l2 @ 0x2295f80] Dequeued v4l2 buffer contains 215040 bytes, but 207360 were expected. Flags: 0x00002001.
/dev/video0: Invalid data found when processing input
```

## basic auth
```
$ sudo apt install apache2-utils
$ sudo htpasswd -c /var/www/.htpasswd streamer-8mamo10
$ sudo vim /etc/nginx/conf.d/default.conf # enable auth_basic
$ sudo systemctl daemon-reload
$ sudo systemctl restart nginx
```

## do streaming
```
$ scripts/start-streaming.sh
```
```
See http://[ip]:55555
```
