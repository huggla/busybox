FROM alpine:edge as stage1

RUN mkdir -p /rootfs/bin \
 && cp -a /bin/busybox /bin/sh /rootfs/bin \
 && find /lib/* ! -name *musl* | xargs rm -rf \
 && cp -a /lib /rootfs/ \
 && ./rootfs/bin/busybox rm -rf /home /usr /var /root /tmp /media /mnt /run /sbin /srv /etc /bin/* || ./rootfs/bin/busybox true \
 && ./rootfs/bin/busybox cp -a /rootfs/bin/* /bin/
 
 FROM scratch
 
 COPY --from=stage1 /rootfs /
 
