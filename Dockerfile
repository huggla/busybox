FROM huggla/alpine-official:20180927-edge as build

RUN mkdir -p /imagefs/bin /imagefs/etc /imagefs/lib /imagefs/sbin /imagefs/usr/bin /imagefs/usr/sbin /imagefs/usr/local/bin /imagefs/tmp /imagefs/var/cache /imagefs/run \
 && cp -a /lib/libz.so* /lib/*musl* /imagefs/lib/ \
 && cp -a /bin/busybox /bin/sh /imagefs/bin/ \
 && cp -a $(find /bin/* -type l | xargs) /imagefs/bin/ \
 && cp -a $(find /sbin/* -type l | xargs) /imagefs/sbin/ \
 && cp -a $(find /usr/bin/* -type l | xargs) /imagefs/usr/bin/ \
 && cp -a $(find /usr/sbin/* -type l | xargs) /imagefs/usr/sbin/ \
 && echo 'root:x:0:0:root:/dev/null:/sbin/nologin' > /imagefs/etc/passwd \
 && echo 'root:x:0:root' > /imagefs/etc/group \
 && echo 'root:::0:::::' > /imagefs/etc/shadow \
 && echo 'starter:x:101:101:starter:/dev/null:/sbin/nologin' >> /imagefs/etc/passwd \
 && echo 'starter:x:0:starter' >> /imagefs/etc/group \
 && echo 'starter:::0:::::' >> /imagefs/etc/shadow \
 && chmod o= /imagefs/etc/* \
 && chmod ugo=rwx /imagefs/tmp \
 && cd /imagefs/var \
 && ln -sf ../tmp tmp \
 && /imagefs/bin/busybox rm -rf /home /usr /var /root /tmp/* /media /mnt /run /sbin /srv /etc /bin/* || /imagefs/bin/busybox true \
 && /imagefs/bin/busybox cp -a /imagefs/bin/* /bin/ \
 && /imagefs/bin/busybox find /imagefs -type l -exec /imagefs/bin/busybox sh -c 'for x; do [ -e "$x" ] || /imagefs/bin/busybox rm "$x"; done' _ {} +
 
FROM scratch as image
 
COPY --from=build /imagefs /
