#!/bin/bash
# Created with crkmaker.sh v.1001
# https://www.board4all.biz/threads/crossover-21-for-linux-patch.735246/

# Download: https://media.codeweavers.com/pub/crossover/cxlinux/demo/
# chmod +x Crossover.v.22.0.1-1.sh
# ./Crossover.v.22.0.1-1.sh

# Crossover.v.22.0.1-1
# https://media.codeweavers.com/pub/crossover/cxlinux/demo/crossover_22.0.1-1.deb
# e5a23dd44ff80d50647fd03eaf8b52a1 *crossover_22.0.1-1.deb
# dc584a13cfb55cbc422b3c795a9f24fc *22.0.1-original\i386-unix\winewrapper.exe.so
# c0a5dd1151e7e77d9bc07c445fe57e1e *22.0.1-original\x86_64-unix\winewrapper.exe.so

# [Name]:/i386-unix/winewrapper.exe.so [Size]:245208 [Original-crc]:c530eccf [Cracked-crc]:0aaf6bfc
# winewrapper.exe.so
# 00017AB0 57 31
# 00017AB1 53 C0
# 00017AB2 E8 C3
# 00017B90 53 31
# 00017B91 E8 C0
# 00017B92 0A C3

# [Name]:/x86_64-unix/winewrapper.exe.so [Size]:246976 [Original-crc]:0d3cb7d9 [Cracked-crc]:a99768ec
# winewrapper.exe.so
# 00018530 53 31
# 00018531 48 C0
# 00018532 89 C3
# 00018600 53 31
# 00018601 48 C0
# 00018602 89 C3

var_s1="$1"
if [ ! "$var_s1" = "undo" ]; then
printf '\x31\xC0\xC3'| sudo dd seek=$((0x00017AB0)) conv=notrunc bs=1 of=/opt/cxoffice/lib/wine/i386-unix/winewrapper.exe.so
printf '\x31\xC0\xC3'| sudo dd seek=$((0x00017B90)) conv=notrunc bs=1 of=/opt/cxoffice/lib/wine/i386-unix/winewrapper.exe.so

printf '\x31\xC0\xC3'| sudo dd seek=$((0x00018530)) conv=notrunc bs=1 of=/opt/cxoffice/lib/wine/x86_64-unix/winewrapper.exe.so
printf '\x31\xC0\xC3'| sudo dd seek=$((0x00018600)) conv=notrunc bs=1 of=/opt/cxoffice/lib/wine/x86_64-unix/winewrapper.exe.so
else
printf '\x57\x53\xE8'| sudo dd seek=$((0x00017AB0)) conv=notrunc bs=1 of=/opt/cxoffice/lib/wine/i386-unix/winewrapper.exe.so
printf '\x53\xE8\x0A'| sudo dd seek=$((0x00017B90)) conv=notrunc bs=1 of=/opt/cxoffice/lib/wine/i386-unix/winewrapper.exe.so

printf '\x53\x48\x89'| sudo dd seek=$((0x00018530)) conv=notrunc bs=1 of=/opt/cxoffice/lib/wine/x86_64-unix/winewrapper.exe.so
printf '\x53\x48\x89'| sudo dd seek=$((0x00018600)) conv=notrunc bs=1 of=/opt/cxoffice/lib/wine/x86_64-unix/winewrapper.exe.so
fi
