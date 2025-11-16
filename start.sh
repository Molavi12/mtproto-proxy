#!/bin/bash
cd /MTProxy-master/objs/bin

# تولید سکرت تصادفی اگر وجود ندارد
if [ ! -f /etc/mtproxy.secret ]; then
    ./mtproto-proxy -u nobody -p 8888 -H 443 -S "$(head -c 16 /dev/urandom | xxd -ps)" -P "" --aes-pwd /etc/passwd --allow-skip-dh --nat-info "$(ip route get 8.8.8.8 | awk '{print $7; exit}')" -M 1 &
else
    ./mtproto-proxy -u nobody -p 8888 -H 443 -S "$(cat /etc/mtproxy.secret)" -P "" --aes-pwd /etc/passwd --allow-skip-dh --nat-info "$(ip route get 8.8.8.8 | awk '{print $7; exit}')" -M 1 &
fi

# منتظر ماندن برای همیشه
wait
