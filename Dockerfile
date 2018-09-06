FROM alpine:edge

RUN cp -a /bin/busybox /bin/sh ./ \
 && ./busybox rm -rf /home /usr /var /root /tmp /media /mnt /run /sbin /srv /etc /bin/* || ./busybox true \
 && ./busybox cp -a /busybox /sh /bin/
 
