FROM alpine:edge as stage1

RUN mkdir -p /rootfs/bin /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin \
 && cp -a /bin/busybox /bin/sh /rootfs/bin/ \
 && find /lib/* ! -name *musl* | xargs rm -rf \
 && cp -a /lib /rootfs/ \
 && cp -a $(find /bin/* -type l | xargs) /rootfs/bin/ \
 && cp -a $(find /sbin/* -type l | xargs) /rootfs/sbin/ \
 && cp -a $(find /usr/bin/* -type l | xargs) /rootfs/usr/bin/ \
 && cp -a $(find /usr/sbin/* -type l | xargs) /rootfs/usr/sbin/ \
 && ./rootfs/bin/busybox rm -rf /home /usr /var /root /tmp /media /mnt /run /sbin /srv /etc /bin/* || ./rootfs/bin/busybox true \
 && ./rootfs/bin/busybox cp -a /rootfs/bin/* /bin/ \
 && ./rootfs/bin/busybox find /rootfs -type l -exec ./rootfs/bin/busybox sh -c 'for x; do [ -e "$x" ] || ./rootfs/bin/busybox rm "$x"; done' _ {} +
 
 FROM scratch
 
 COPY --from=stage1 /rootfs /
 
