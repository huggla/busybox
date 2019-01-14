FROM huggla/alpine-official as alpine

RUN mkdir -m 755 /imagefs \
 && mkdir -m 755 /imagefs/lib /imagefs/usr \
 && mkdir -m 755 /imagefs/usr/local /imagefs/usr/lib \
 && mkdir -m 755 /imagefs/usr/local/bin \
 && mkdir -m 770 /imagefs/.r \
 && mkdir -m 700 /imagefs/bin /imagefs/sbin /imagefs/.dockerenv \
 && mkdir -m 750 /imagefs/etc /imagefs/var /imagefs/run \
 && mkdir -m 770 /imagefs/tmp \
 && mkdir -m 700 /imagefs/usr/bin /imagefs/usr/sbin \
 && mkdir -m 750 /imagefs/var/cache \
 && cp -a /lib/libz.so* /lib/*musl* /imagefs/lib/ \
 && cp -a /bin/busybox /bin/sh /imagefs/bin/ \
 && cp -a $(find /bin/* -type l | xargs) /imagefs/bin/ \
 && cp -a $(find /sbin/* -type l | xargs) /imagefs/sbin/ \
 && cp -a $(find /usr/bin/* -type l | xargs) /imagefs/usr/bin/ \
 && cp -a $(find /usr/sbin/* -type l | xargs) /imagefs/usr/sbin/ \
 && echo 'root:x:0:0:root:/dev/null:/sbin/nologin' > /imagefs/etc/passwd \
 && echo 'root:x:0:' > /imagefs/etc/group \
 && echo 'starter:x:101:101:starter:/dev/null:/sbin/nologin' >> /imagefs/etc/passwd \
 && echo 'starter:x:101:' >> /imagefs/etc/group \
 && chmod 640 /imagefs/etc/passwd /imagefs/etc/group \
 && cd /imagefs/var \
 && ln -sf ../tmp tmp \
 && /imagefs/bin/busybox rm -rf /home /usr /var /root /tmp/* /media /mnt /run /sbin /srv /etc /bin/* || /imagefs/bin/busybox true \
 && /imagefs/bin/busybox cp -a /imagefs/bin/* /bin/ \
 && /imagefs/bin/busybox find /imagefs -type l -exec /imagefs/bin/busybox sh -c 'for x; do [ -e "$x" ] || /imagefs/bin/busybox rm "$x"; done' _ {} + \
 && cd /imagefs \
 && /imagefs/bin/busybox find * ! -type d ! -type c -exec /imagefs/bin/busybox md5sum {} + | /imagefs/bin/busybox sort -u - | /imagefs/bin/busybox gzip -9 > /onbuild-exclude.filelist.gz \
 && /imagefs/bin/busybox mv /onbuild-exclude.filelist.gz /imagefs/onbuild-exclude.filelist.gz \
 && /imagefs/bin/busybox chmod 600 /imagefs/onbuild-exclude.filelist.gz

FROM scratch as image

COPY --from=alpine /imagefs /

RUN chgrp 101 /.r
