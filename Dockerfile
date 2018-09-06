FROM alpine:edge as stage1

RUN cp -a /bin/busybox /bin/sh ./ \
 && find /lib/* ! -name *musl* | xargs rm -rf \
 && ./busybox rm -rf /home /usr /var /root /tmp /media /mnt /run /sbin /srv /etc /bin/* || ./busybox true \
 && ./busybox cp -a /busybox /sh /bin/
 
 FROM scratch
 
 COPY --from=stage1 / /
 
