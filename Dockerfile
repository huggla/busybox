FROM huggla/alpine-official as stage1

RUN mkdir -p /rootfs/bin /rootfs/lib /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin /rootfs/usr/local/bin /rootfs/tmp /rootfs/var/cache /rootfs/run \
 && apk --no-cache add $APKS \
 && cp -a /lib/libz.so* /lib/*musl* /rootfs/lib/ \
 && cp -a /bin/busybox /bin/sh /rootfs/bin/ \
 && cp -a $(find /bin/* -type l | xargs) /rootfs/bin/ \
 && cp -a $(find /sbin/* -type l | xargs) /rootfs/sbin/ \
 && cp -a $(find /usr/bin/* -type l | xargs) /rootfs/usr/bin/ \
 && cp -a $(find /usr/sbin/* -type l | xargs) /rootfs/usr/sbin/ \
 && echo 'root:x:0:0:root:/dev/null:/sbin/nologin' > /rootfs/etc/passwd \
 && echo 'root:x:0:root' > /rootfs/etc/group \
 && echo 'root:::0:::::' > /rootfs/etc/shadow \
 && chmod o= /rootfs/etc/* \
 && chmod ugo=rwx /rootfs/tmp \
 && cd /rootfs/var \
 && ln -s ../tmp tmp \
 && /rootfs/bin/busybox rm -rf /home /usr /var /root /tmp/* /media /mnt /run /sbin /srv /etc /bin/* || /rootfs/bin/busybox true \
 && /rootfs/bin/busybox cp -a /rootfs/bin/* /bin/ \
 && /rootfs/bin/busybox find /rootfs -type l -exec /rootfs/bin/busybox sh -c 'for x; do [ -e "$x" ] || /rootfs/bin/busybox rm "$x"; done' _ {} +
 
FROM scratch
 
COPY --from=stage1 /rootfs /
