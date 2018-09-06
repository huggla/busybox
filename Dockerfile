FROM alpine:edge as stage1

RUN mkdir -p /rootfs/bin /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin /rootfs/usr/local/bin /rootfs/usr/lib/sudo /rootfs/etc/sudoers.d \
 && find /lib/* ! -name *musl* | xargs rm -rf \
 && apk --no-cache add sudo zlib \
 && cp -a /bin/busybox /bin/sh /rootfs/bin/ \
 && cp -a /lib /rootfs/ \
 && cp -a $(find /bin/* -type l | xargs) /rootfs/bin/ \
 && cp -a $(find /sbin/* -type l | xargs) /rootfs/sbin/ \
 && cp -a $(find /usr/bin/* -type l | xargs) /rootfs/usr/bin/ \
 && cp -a $(find /usr/sbin/* -type l | xargs) /rootfs/usr/sbin/ \
 && cp -a /usr/bin/sudo /rootfs/usr/local/bin/ \
 && cp -a /usr/lib/sudo/libsudo* /usr/lib/sudo/sudoers* /rootfs/usr/lib/sudo/ \
 && echo 'root:x:0:0:root:/dev/null:/sbin/nologin' > /rootfs/etc/passwd \
 && echo 'root:x:0:root' > /rootfs/etc/group \
 && echo 'root:::0:::::' > /rootfs/etc/shadow \
 && ./rootfs/bin/busybox rm -rf /home /usr /var /root /tmp /media /mnt /run /sbin /srv /etc /bin/* || ./rootfs/bin/busybox true \
 && ./rootfs/bin/busybox cp -a /rootfs/bin/* /bin/ \
 && ./rootfs/bin/busybox find /rootfs -type l -exec ./rootfs/bin/busybox sh -c 'for x; do [ -e "$x" ] || ./rootfs/bin/busybox rm "$x"; done' _ {} +
 
 FROM scratch
 
 COPY --from=stage1 /rootfs /
 
 RUN chmod u+s /usr/local/bin/sudo
