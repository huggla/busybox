FROM alpine:edge

RUN cp -a /bin/busybox /bin/sh ./ \
 && ./busybox rm -rf /home /usr /var /root /tmp /media /mnt /run /sbin /srv /etc || ./busybox true \
 && ./busybox mkdir /bin \
 && ./busybox cp -a /busybox /sh /bin/
 
